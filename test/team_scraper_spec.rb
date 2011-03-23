require '../team_scraper.rb'
describe TeamInfoRequest, "A request for team information" do
  @@team_stats = ['1', '1918', '11', '1', '0', '12', '22.00', '15.75']

  request = TeamInfoRequest.new('http://www2.usfirst.org/2011comp/events/gt/rankings.html')
  # match_result_request = TeamInfoRequest.new('http://www2.usfirst.org/2011comp/events/GT/matchresults.html')
  match_result_request = TeamInfoRequest.new('test_page.html')
  num_of_team_request = TeamInfoRequest.new('http://www2.usfirst.org/2011comp/events/GT/schedulequal.html')

  match_result_request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
  request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
  num_of_team_request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)

#----------------------------------------------------------------------------
  it "should return team's stats when given a rank" do
    request.getStatsByRank(1).should == @@team_stats
  end

  it "should return team stats when given a team's number" do
    request.getStatsByTeamNumber(1918).should == @@team_stats
  end

  it "should return the team's match results" do
    match_result_request.getTeamMatchResults(1918).should include(['11:20 AM', '5', '2586', '3772', '3537', '1918', '815', '1596', '2', '0'])
  end

  it "should return current match" do
    match_result_request.getCurrentMatch
  end
end
