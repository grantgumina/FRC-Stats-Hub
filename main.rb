require 'rubygems'
require 'sinatra'
require 'frc_scraper.rb'
require 'event_list_scraper.rb'
require 'team_scraper.rb'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3', :database => 'db/event_info.sqlite3.db'
)

begin
ActiveRecord::Migration.class_eval do
  create_table :event_urls do |t|
    t.primary_key :id
    t.string :event_short_hand_name
    t.string :event_name
   end
end

rescue
  #nothing - table has already been created
end


helpers do 
  def create_event_urls(event_short_names)
    base_url = '/event/'
    
    event_short_names.map! do |r|
      r.scan(/2010(.+)/)
    end

    event_short_names.map! do |r|
      r = base_url + r.to_s
    end
    return event_short_names
  end

  def create_team_urls(event, team_numbers)
    base_url = '/team/'
    team_numbers.map! do |tn|
      tn = base_url + tn.to_s
    end
  end
end

class EventUrl < ActiveRecord::Base
end


get '/' do
  @event_short_names = []
  @event_names = []
  t1 = Thread.new do
  req = EventListInfoRequest.new('http://www.thebluealliance.net/tbatv/')
    @event_names = req.findData('<tr class="table_row0">', '</table>', /title="(.*?)"/)
  end

  t2 = Thread.new do
  req = EventListInfoRequest.new('http://www.thebluealliance.net/tbatv/')
    @event_short_names = req.findData('<tr class="table_row0">', '</table>', /event\/(.*?)"/)
  end

  t1.join
  t2.join
  @event_urls = create_event_urls(@event_short_names)
  haml :index
end

get '/event/:short_name' do |event|
  request = TeamListInfoRequest.new("https://my.usfirst.org/myarea/index.lasso?page=teamlist&menu=false&event=#{event}&year=2010&event_type=FRC")
  @team_numbers = request.findData('<tr bgcolor="#FFFFFF">', '</table>', /">(.+)<\/a/)
  @team_urls = create_team_urls(event, @team_numbers)
  haml :event
end

get '/event/:short_name/team/:team_number' do 
  haml :team
end
