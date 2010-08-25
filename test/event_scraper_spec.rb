require '../event_list_scraper.rb'
require 'open-uri'

describe EventListInfoRequest, 'A request for a list of teams attending an event' do
  request = EventListInfoRequest.new

  request.setUrl('http://www.thebluealliance.net/tbatv/')
  request.downloadData
  results = request.findData('<tr class="table_row0">', '</table>', /title="(.*?)"/)
  # results = request.findData('<tr class="table_row0">', '</table>', /event\/(.*?)"/)

  it "should return an array of all the FRC events" do
    results.should include("BAE Granite State Regional", "Las Vegas Regional")
  end

  it "should return an array of all the FRC events short hand ids" do
    # results.should include("BAE Granite State Regional", "Las Vegas Regional")
  end
end
