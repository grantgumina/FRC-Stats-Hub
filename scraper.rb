require 'open-uri'
class FRCInfoRequest
  # instance variables
  @data 
  @stats
  @url

  # global variables
  @@number_of_fields = 6   # a field would be rank, team #, seeding pts, etc.

#=====================================================================
  # Data
#=====================================================================
  def downloadData
    @data = open(@url)
  end
 
  def limitData
    text = @data.read; nil
    start = text.index('<TR style="background-color:#FFFFFF;" >')
    stop = text.index( '</table>', start)
    restricted_text = text[start..stop]
    nested_stats = restricted_text.scan(/>(.+)</)
    # important line - removes nested arrays
    @stats = nested_stats.flatten
  end

#======================================================================  
  # URL
#======================================================================
  def getUrl
    return @url
  end

  def setUrl(url)
    @url = url
  end

#======================================================================
  # Stats
#======================================================================
  def displayStatsByRank(rank)
    return cycleThroughStats(0, rank)
  end

  def displayStatsByTeamNumber(number)
   return cycleThroughStats(1, number)
  end

#=====================================================================
  # Printing
#=====================================================================
  def printTeamStats(team_stats)
    puts "\n"
    puts " Team Stats ".center(40, '=')

    puts " Rank: #{team_stats[0].center(20)}"
    puts " Team Number: #{team_stats[1].center(20)}"
    puts " Matches Played: #{team_stats[2].center(20)}"
    puts " Seeding Points: #{team_stats[3].center(20)}"
    puts " Coopertition Bonus: #{team_stats[4]}"
    puts " Hanging Points: #{team_stats[5]}"
    puts "=".center(40, '=')
  end

  def putsNoF
    return @@number_of_fields
  end

#=====================================================================
  # Private
#=====================================================================
  def getNumberOfTeams
    number_of_teams = @stats.length / @@number_of_fields 
    return number_of_teams
  end

  # cycles through the array of stats. If the line_value you're looking for
  # is the same as the same as the value in array[field_number] then it
  # returns the stats.
  def cycleThroughStats(field_number, line_value)
    amount_of_cycles = getNumberOfTeams
    start = 0  
    stop= @@number_of_fields - 1
    counter = 1 
    while counter <= amount_of_cycles
      team_stats = @stats[start..stop]
      
      if line_value.to_s == team_stats[field_number]
        return team_stats
      end
      
      start += @@number_of_fields
      stop += @@number_of_fields
      counter +=  1 
    end 
    # yeah, probably need to handle not finding the value better
    return team_stats
  end
#=====================================================================
  private :getNumberOfTeams
  private :cycleThroughStats
end
