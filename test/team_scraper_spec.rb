require '../team_scraper.rb'
require 'open-uri'
describe TeamInfoRequest, "A request for team information" do
  @@team_stats = Array['38', '2188', '11', '48.00', '12.00','4.00']
  request = TeamInfoRequest.new
  
  request.setUrl("http://www2.usfirst.org/2010comp/Events/GT/rankings.html")

  request.downloadData
  request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
#----------------------------------------------------------------------------
  # I know this test sucks, but I don't want to hard code the HTML into this file. So there.
  it "should not have an empty URL" do  
    request.setUrl("http://www2.usfirst.org/2010comp/Events/GT/rankings.html")
    request.getUrl.should_not == nil or ""
  end

  it "should display team's stats when given a rank" do
    request.displayStatsByRank(38).should == @@team_stats
  end

  #look at parseData, it doesn't return anything!
  it "should display team stats when given a team's number" do
    request.displayStatsByTeamNumber(2188).should == @@team_stats
  end
  request.printTeamStats(request.displayStatsByTeamNumber(2188))
end
