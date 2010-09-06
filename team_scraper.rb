require File.expand_path(File.dirname(__FILE__) + '/frc_scraper.rb')
class TeamInfoRequest < FRCInfoRequest
  # global variables

#======================================================================
  # Stats
#======================================================================
  def getStatsByRank(rank)
    return cycleThroughStats(0, rank, 6)
  end

  def getStatsByTeamNumber(number)
    return cycleThroughStats(1, number, 6)
  end


  def getTeamMatchResults(number)
    all = []
    all[0] = cycleThroughMatchResults(2, number, 10)
    all[1] = cycleThroughMatchResults(3, number, 10)
    all[2] = cycleThroughMatchResults(4, number, 10)
    all[3] = cycleThroughMatchResults(5, number, 10)
    all[4] = cycleThroughMatchResults(6, number, 10)
    all[5] = cycleThroughMatchResults(7, number, 10)

    return all
  end

#=====================================================================
  # Private
#=====================================================================
  def getNumberOfRows(number_of_fields)
    number_of_rows = @stats.length / number_of_fields 
    return number_of_rows
  end

  # cycles through the array of stats. If the line_value you're looking for
  # is the same as the value in array[field_number] then it
  # returns the stats.
  def cycleThroughStats(field_number, line_value, number_of_fields)
    rows = getNumberOfRows(number_of_fields)
    start = 0  
    stop = number_of_fields - 1
    counter = 1 

    while counter <= rows
      team_stats = @stats[start..stop]

      if line_value.to_s == team_stats[field_number]
        return team_stats      end

      start += number_of_fields
      stop += number_of_fields
      counter +=  1 
    end 
    # yeah, probably need to handle not finding the value better
    return team_stats 
  end

  def cycleThroughMatchResults(field_number, line_value, number_of_fields)

    rows = getNumberOfRows(number_of_fields)
    start = 0  
    stop = number_of_fields - 1
    counter = 1 
    returned_stats = []


    while counter <= rows
      team_stats = @stats[start..stop]

      if field_number > 4
        team_stats[field_number].inject("Blue")
      elsif field_number < 4
        team_stats[field_number].inject("Red")
      end

      if line_value == team_stats[field_number].to_i
        returned_stats.concat(team_stats)
      end

      start += number_of_fields
      stop += number_of_fields
      counter +=  1 
    end 
    # yeah, probably need to handle not finding the value better
    return returned_stats
  end
#=====================================================================
  private :getNumberOfRows
  private :cycleThroughStats
end
