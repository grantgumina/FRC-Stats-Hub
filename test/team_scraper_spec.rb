require '../team_scraper.rb'
describe TeamInfoRequest, "A request for team information" do
  @@team_stats = ['38', '2188', '11', '48.00', '12.00','4.00']
  request = TeamInfoRequest.new('http://www2.usfirst.org/2010comp/events/gt/rankings.html')
  match_result_request = TeamInfoRequest.new('http://www2.usfirst.org/2010comp/events/GT/matchresults.html')
  
  match_result_request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
  request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
#----------------------------------------------------------------------------
  it "should return team's stats when given a rank" do
    request.getStatsByRank(38).should == @@team_stats
  end

  #look at parseData, it doesn't return anything!
  it "should return team stats when given a team's number" do
    request.getStatsByTeamNumber(2188).should == @@team_stats
  end

  it "should return the team's match results" do
    puts match_result_request.getTeamMatchResults(1918)
    # match_result_request.getTeamMatchResults(1918).should include(["9:18 AM", "50", "1918", "1783", "2719", "3114", "3357", "2245", "5", "0", "12:36 PM", "74", "1918", "904", "2771", "1711", "1596", "2474", "4", "4"], ["12:33 PM", "9", "1896", "1918", "1711", "2000", "3423", "107", "5", "0"])
  end
end
