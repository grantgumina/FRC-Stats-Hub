require '../event_list_scraper.rb'

describe EventListInfoRequest, 'A request for a list of events' do
  request = EventListInfoRequest.new('http://www.thebluealliance.net/tbatv/')

  results = request.findData('<tr class="table_row0">', '</table>', /title="(.*?)"/)

  it "should return an array of all the FRC events" do
    results.should include("BAE Granite State Regional", "Las Vegas Regional")
  end
end

describe EventListInfoRequest, 'A request for a list of events' do
  request = EventListInfoRequest.new('http://www.thebluealliance.net/tbatv/')

  results = request.findData('<tr class="table_row0">', '</table>', /event\/(.*?)"/)
  results.map! do |r|
    r.scan(/2010(.+)/) 
  end

  results.flatten!

  it "should return an array of all the FRC events short hand ids" do
    results.should include("gg", "sdc")
  end
end
