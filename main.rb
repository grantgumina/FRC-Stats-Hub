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
  def create_event_urls
    base_url = '/event/'
    
    request = EventListInfoRequest.new('http://www.thebluealliance.net/tbatv/')
    results = request.findData('<tr class="table_row0">', '</table>', /event\/(.*?)"/)
    results.map! do |r|
      r.scan(/2010(.+)/)
    end

    results.map! do |r|
      r = base_url + r.to_s
    end
    return results
  end

  def create_team_urls
    base_url = '/team/'
  end
end

class EventUrl < ActiveRecord::Base
end

get '/' do
  req = EventListInfoRequest.new('http://www.thebluealliance.net/tbatv/')
  @event_names = req.findData('<tr class="table_row0">', '</table>', /title="(.*?)"/)

  @event_urls = create_event_urls
  haml :index
end

get '/event/:short_name' do |n|
  haml :event
end

get '/event/:short_name/team/:team_number' do |tn|

end
