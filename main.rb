require 'rubygems'
require 'sinatra'
require 'frc_scraper.rb'
require 'event_list_scraper.rb'
require 'team_scraper.rb'
require 'team_list_scraper.rb'

helpers do 
  def create_event_urls(event_short_names)
    base_url = '/event/'
    
    event_short_names.map! do |r|
      r.scan(/2011(.+)/)
    end

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
    t1 = Thread.new do
    req = EventListInfoRequest.new('http://www.thebluealliance.com/events/')
      @event_names = req.findData('<ul class="infoList">', '</ul>', /">(.*?)\s</)
    end

    t2 = Thread.new do
    req = EventListInfoRequest.new('http://www.thebluealliance.com/events/')
      @event_short_names = req.findData('<ul class="infoList">', '</ul>', /event\/(.*?)"/)
    end

    t1.join
    t2.join
    @event_names.each do |en|
      en.strip!
    end

    @event_urls = create_event_urls(@event_short_names)
    haml :index 
  rescue
    haml :error, :layout => false
  end
end

get '/event/:short_name' do |@event|
  request = TeamListInfoRequest.new("https://my.usfirst.org/myarea/index.lasso?page=teamlist&menu=false&event=#{@event}&year=2011&event_type=FRC")
  @team_numbers = request.findData('<tr bgcolor="#FFFFFF">', '</table>', /">(.+)<\/a/)
  
  ranking_request = TeamInfoRequest.new("http://www2.usfirst.org/2011comp/events/#{@event}/rankings.html")
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
end

get '/event/:short_name/team/:team_number' do
  tn_request = TeamListInfoRequest.new("https://my.usfirst.org/myarea/index.lasso?page=teamlist&menu=false&event=#{params[:short_name]}&year=2011&event_type=FRC")
  @team_numbers = tn_request.findData('<tr bgcolor="#FFFFFF">', '</table>', /">(.+)<\/a/)
  @team_numbers.map! do |x| 
    x.to_i
  end

  request = TeamInfoRequest.new("http://www2.usfirst.org/2011comp/events/#{params[:short_name]}/rankings.html")
  match = TeamInfoRequest.new("http://www2.usfirst.org/2011comp/events/#{params[:short_name]}/matchresults.html")

  request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
  match.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)

  @team_number = params[:team_number]
  @team_stats = request.getStatsByTeamNumber(params[:team_number])
  @team_match_results = match.getTeamMatchResults(params[:team_number])

  haml :team
end
