require '../team_list_scraper.rb'

describe TeamListInfoRequest, "A request for a list of teams attending an event" do
  request = TeamListInfoRequest.new("https://my.usfirst.org/myarea/index.lasso?page=teamlist&menu=false&event=gt&year=2010&event_type=FRC")
  results = request.findData('<tr bgcolor="#FFFFFF">', '</table>', /">(.+)<\/a/)

  it 'should return an array of teams attending an event' do
    results.should include("830", "2188", "835")
  end
end
