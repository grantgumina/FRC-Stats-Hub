require 'rubygems'
require 'sinatra'
require 'frc_scraper.rb'
require 'event_scraper.rb'
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

# Enter competition information
# Traverse City, Michigan
#
#


class EventUrl < ActiveRecord::Base
end

get '/' do
  @event_url = EventUrl.all.count
  haml :index
end


