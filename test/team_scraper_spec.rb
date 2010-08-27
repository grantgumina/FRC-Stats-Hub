require '../team_scraper.rb'
describe TeamInfoRequest, "A request for team information" do
  @@team_stats = Array['38', '2188', '11', '48.00', '12.00','4.00']
  request = TeamInfoRequest.new('http://www2.usfirst.org/2010comp/Events/GT/rankings.html')
  
  request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
#----------------------------------------------------------------------------
  it "should display team's stats when given a rank" do
    request.getStatsByRank(38).should == @@team_stats
  end

  #look at parseData, it doesn't return anything!
  it "should display team stats when given a team's number" do
    request.getStatsByTeamNumber(2188).should == @@team_stats
  end
end
