require 'rubygems'
require 'sinatra'
require 'haml'
require 'frc_scraper.rb'
require 'event_list_scraper.rb'
require 'team_scraper.rb'
require 'team_list_scraper.rb'

helpers do 
  def create_event_urls(event_short_names)
    base_url = '/event/'

    event_short_names.map! do |r|
      r = base_url + r.to_s
    end
			
    return event_short_names
  end

  def create_team_urls(event, team_numbers)
    base_url = '/team/'
    team_urls = team_numbers.map do |tn|
      tn = base_url + tn.to_s
    end
    return team_urls
  end
end

get '/' do
  @event_short_names = []
  @event_names = []
  begin
	req = EventListInfoRequest.new('http://www.thebluealliance.com/events/')
		@event_data = req.findData('<ul class="infoList">', '</ul>', /\/2012(.*?)">(.*?)</)
		@event_short_names = @event_data.values_at(* @event_data.each_index.select {|e| e.even?})
		@event_names = @event_data.values_at(* @event_data.each_index.select {|e| e.odd?})
    @event_urls = create_event_urls(@event_short_names)

    haml :index 
  rescue
    haml :error, :layout => false
  end
end

get '/event/:short_name' do |@event|
  begin
    request = TeamListInfoRequest.new("https://my.usfirst.org/myarea/index.lasso?page=teamlist&menu=false&event=#{@event}&year=2012&event_type=FRC")
    @team_numbers = request.findData('<tr bgcolor="#FFFFFF">', '</table>', /">(.+)<\/a/)

    ranking_request = TeamInfoRequest.new("http://www2.usfirst.org/2012comp/events/#{@event}/rankings.html")
    ranking_request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)

    @results = []

    @team_urls = create_team_urls(@event, @team_numbers)  
    @team_numbers.map! do |x| 
      x.to_i
    end

    @team_numbers.length.times do |rank|
      rank += 1
      @results.push(ranking_request.getStatsByRank(rank))
    end
    haml :event
  rescue
    haml :error 
  end

end

get '/event/:short_name/team/:team_number' do
  begin
    tn_request = TeamListInfoRequest.new("https://my.usfirst.org/myarea/index.lasso?page=teamlist&menu=false&event=#{params[:short_name]}&year=2012&event_type=FRC")
    @team_numbers = tn_request.findData('<tr bgcolor="#FFFFFF">', '</table>', /">(.+)<\/a/)
    @team_numbers.map! do |x| 
      x.to_i
    end

    ranking_request = TeamInfoRequest.new("http://www2.usfirst.org/2012comp/events/#{params[:short_name]}/rankings.html")
    match_request = TeamInfoRequest.new("http://www2.usfirst.org/2012comp/events/#{params[:short_name]}/matchresults.html")

    ranking_request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
    match_request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.*?)</)

    @team_number = params[:team_number]
    @team_stats = ranking_request.getStatsByTeamNumber(params[:team_number])

    @team_match_results = match_request.getTeamMatchResults(params[:team_number])
    
    @results = []

    @team_urls = create_team_urls(@event, @team_numbers)  
    @team_numbers.length.times do |rank|
      rank += 1
      @results.push(ranking_request.getStatsByRank(rank))
    end

    haml :team
  rescue
    haml :error
  end
end
