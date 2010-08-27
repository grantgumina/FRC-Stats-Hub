require File.expand_path(File.dirname(__FILE__) + '/frc_scraper.rb')
class TeamInfoRequest < FRCInfoRequest
  # global variables
  @@number_of_fields = 6   # a field would be rank, team #, seeding pts, etc.

#======================================================================
  # Stats
#======================================================================
  def getStatsByRank(rank)
    return cycleThroughStats(0, rank)
  end

  def getStatsByTeamNumber(number)
    return cycleThroughStats(1, number)
  end

#=====================================================================
  # Private
#=====================================================================
  def getNumberOfTeams
    number_of_teams = @@stats.length / @@number_of_fields 
    return number_of_teams
  end

  # cycles through the array of stats. If the line_value you're looking for
  # is the same as the same as the value in array[field_number] then it
  # returns the stats.
  def cycleThroughStats(field_number, line_value)
    getNumberOfTeams
    start = 0  
    stop = @@number_of_fields - 1
    counter = 1 
    while counter <= getNumberOfTeams
      team_stats = @@stats[start..stop]
      
      if line_value.to_s == team_stats[field_number]
        return team_stats.flatten
      end
      
      start += @@number_of_fields
      stop += @@number_of_fields
      counter +=  1 
    end 
    # yeah, probably need to handle not finding the value better
    return team_stats.flatten
  end
#=====================================================================
  private :getNumberOfTeams
  private :cycleThroughStats
end
