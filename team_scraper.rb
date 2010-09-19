require File.expand_path(File.dirname(__FILE__) + '/frc_scraper.rb')
class TeamInfoRequest < FRCInfoRequest
  # global variables
#======================================================================
  # Stats
#======================================================================
  # TODO: figure out how to dynamically find the number of matches per team
  
  # def getMatchesPerTeam
  #   number_of_cells = @stats.length
  #   return matches_per_team = number_of_cells / 8
  # end

  def getStatsByRank(rank)
    rank = rank.to_i
    return cycleThroughStats(0, rank, 6)
  end

  def getStatsByTeamNumber(number)
    number = number.to_i
    return cycleThroughStats(1, number, 6)
  end

  def getTeamMatchResults(number)
    number = number.to_i
    all = cycleThroughMatchResults(2, number, 10)
    # all[1] = cycleThroughMatchResults(3, number, 10)
    # all[2] = cycleThroughMatchResults(4, number, 10)
    # all[3] = cycleThroughMatchResults(5, number, 10)
    # all[4] = cycleThroughMatchResults(6, number, 10)
    # all[5] = cycleThroughMatchResults(7, number, 10)

    # foobar = all[0] + all[1] + all[2] + all[3] + all[4] + all[5]

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
        return team_stats    
      end

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
    mini_counter = 1
    returned_stats = []

    while counter <= rows
      team_stats = @stats[start..stop]

      case line_value
      when team_stats[2].to_i
        returned_stats[mini_counter] = team_stats
        mini_counter += 1
      when team_stats[3].to_i
        returned_stats[mini_counter] = team_stats
        mini_counter += 1
      when team_stats[4].to_i
        returned_stats[mini_counter] = team_stats
        mini_counter += 1
      when team_stats[5].to_i
        returned_stats[mini_counter] = team_stats
        mini_counter += 1
      when team_stats[6].to_i
        returned_stats[mini_counter] = team_stats
        mini_counter += 1
      when team_stats[7].to_i
        returned_stats[mini_counter] = team_stats
        mini_counter += 1
      end

      start += number_of_fields
      stop += number_of_fields
      counter +=  1 

    end 

    returned_stats.reject! do |r|
      r.class == NilClass
    end

    return returned_stats
  end
#=====================================================================
  private :getNumberOfRows
  private :cycleThroughStats
end
