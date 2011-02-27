require '../team_scraper.rb'
describe TeamInfoRequest, "A request for team information" do
  @@team_stats = ['38', '2188', '11', '48.00', '12.00','4.00']
  more_stats = ['3',	'2645',	'12',	'87.00',	'26.00',	'12.00']
  request = TeamInfoRequest.new('http://www2.usfirst.org/2011comp/events/gt/rankings.html')
  match_result_request = TeamInfoRequest.new('http://www2.usfirst.org/2011comp/events/GT/matchresults.html')
  num_of_team_request = TeamInfoRequest.new('http://www2.usfirst.org/2011comp/events/GT/schedulequal.html')

  match_result_request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
  request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)
  num_of_team_request.findData('<TR style="background-color:#FFFFFF;" >', '</table>', />(.+)</)

#----------------------------------------------------------------------------
  it "should return team's stats when given a rank" do
    request.getStatsByRank(38).should == @@team_stats
    request.getStatsByRank(3).should == more_stats
  end

  it "should return team stats when given a team's number" do
    request.getStatsByTeamNumber(2188).should == @@team_stats
    request.getStatsByTeamNumber(2645).should == more_stats
  end

  it "should return the team's match results" do
    match_result_request.getTeamMatchResults(1918).should include(["11:50 AM", "5", "2405", "2959", "66", "1918", "818", "2015", "0", "5"], ["12:33 PM", "9", "1896", "1918", "1711", "2000", "3423", "107", "5", "0"], ["3:18 PM", "19", "2153", "107", "1918", "2188", "66", "904", "7", "4"], ["3:43 PM", "22", "2188", "3234", "3357", "74", "1918", "141", "7", "3"], ["4:50 PM", "26", "2645", "830", "2405", "1254", "1918", "2000", "3", "7"], ["6:28 PM", "38", "2246", "1254", "858", "3115", "1918", "2245", "5", "3"], ["7:02 PM", "43", "94", "141", "2245", "1918", "830", "835", "3", "6"], ["9:18 AM", "50", "1918", "1783", "2719", "3114", "3357", "2245", "5", "0"], ["10:28 AM", "57", "3114", "2015", "3115", "3098", "3357", "1918", "2", "6"], ["10:48 AM", "60", "85", "818", "3098", "1918", "1189", "857", "0", "4"], ["11:20 AM", "64", "858", "2645", "1918", "2153", "835", "3098", "6", "1"], ["12:36 PM", "74", "1918", "904", "2771", "1711", "1596", "2474", "4", "4"])
  end
end
