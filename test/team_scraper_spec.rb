require '../team_scraper.rb'
describe TeamInfoRequest, "A request for team information" do
  @@team_stats = ['3', '1918', '6', '1', '0', '7', '12.00', '10.14']

  more_stats = ['3',	'2645',	'12',	'87.00',	'26.00',	'12.00']
  request = TeamInfoRequest.new('http://www2.usfirst.org/2011comp/events/gt/rankings.html')
  match_result_request = TeamInfoRequest.new('http://www2.usfirst.org/2011comp/events/GT/matchresults.html')
  num_of_team_request = TeamInfoRequest.new('http://www2.usfirst.org/2011comp/events/GT/schedulequal.html')

  match_result_request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
  request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
  num_of_team_request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)

#----------------------------------------------------------------------------
  it "should return team's stats when given a rank" do
    request.getStatsByRank(3).should == @@team_stats
  end

  it "should return team stats when given a team's number" do
    request.getStatsByTeamNumber(1918).should == @@team_stats
  end

  it "should return the team's match results" do
    match_result_request.getTeamMatchResults(1918).should include(['11:20 AM', '5', '2586', '3772', '3537', '1918', '815', '1596', '2', '0'])
  end
end
