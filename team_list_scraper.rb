require 'time'
require File.expand_path(File.dirname(__FILE__) + '/frc_scraper.rb')
class TeamListInfoRequest < FRCInfoRequest
  @@year = Time.now.year.to_s

  def initialize(event_short_name)
    @@event_short_name = event_short_name
  end

  @@url = "https://my.usfirst.org/myarea/index.lasso?page=teamlist&menu=false&event=#{@@event_short_name}&year=#{@@year}&event_type=FRC"
end
