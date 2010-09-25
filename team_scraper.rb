require File.expand_path(File.dirname(__FILE__) + '/frc_scraper.rb')
class TeamInfoRequest < FRCInfoRequest
  # global variables
#======================================================================
  # Stats
#======================================================================
  def getStatsByRank(rank)
    rank = rank.to_i
    return cycleThroughStats(0, rank, 6)
  end

  def getStatsByTeamNumber(number)
    return cycleThroughStats(1, number.to_i, 6)
  end

  def getTeamMatchResults(number)
    return cycleThroughMatchResults(2, number.to_i, 10)
  end

#=====================================================================
  # Private
#=====================================================================
  def getNumberOfRows(number_of_fields)
    number_of_rows = @stats.length / number_of_fields 
    return number_of_rows
  end

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
