require 'open-uri'
class FRCInfoRequest
  @@data = ''
  @@stats = ''

#=====================================================================
  # Data
#=====================================================================
  def initialize(url)
    @@data = open(url)
  end
  
  def findData(html_start, html_stop, regex)
    text = @@data.read; nil
    start = text.index(html_start)
    stop = text.index(html_stop, start)
    restricted_text = text[start..stop]
    nested_stats = restricted_text.scan(regex)
    @@stats = nested_stats 
    
    # important line - removes nested arrays
    return nested_stats.flatten.uniq
  end
end
