require '../event_list_scraper.rb'

describe EventListInfoRequest, 'A request for a list of events' do
  request = EventListInfoRequest.new('http://www.thebluealliance.com/events/')

  results = request.findData('<ul class="infoList">', '</ul>', /">(.*?)\s</)

  results.each do |r| 
    r.strip!
  end

  it "should return an array of all the FRC events" do
    results.should include("Lone Star Regional", "BAE Systems/Granite State Regional")
  end
end

describe EventListInfoRequest, 'A request for a list of events' do
  request = EventListInfoRequest.new('http://www.thebluealliance.com/events/')

  results = request.findData('<ul class="infoList">', '</ul>', /event\/(.*?)"/) 
  results.map! do |r|
    r.scan(/2011(.+)/) 
  end

  results.flatten!

  it "should return an array of all the FRC events short hand ids" do
    results.should include("gg", "sdc")
  end
end
