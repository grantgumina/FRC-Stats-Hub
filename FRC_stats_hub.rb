require 'rubygems'
require 'sinatra'
# require 'scraper.rb'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3', :database => 'db/comets_robotics_stats_hub.sqlite3.db'
)

ActiveRecord::Migration.class_eval do
  create_table :event_urls do |t|
    t.string  :title
    t.text :body
   end
end

class EventUrl < ActiveRecord::Base
end

get '/' do
  @event_url = EventUrl.all
  haml :index
end


