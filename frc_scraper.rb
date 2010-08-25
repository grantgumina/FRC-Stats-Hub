require 'open-uri'
class FRCInfoRequest
  @@data = ''
  @@url = ''
  @@stats = ''

#=====================================================================
  # Data
#=====================================================================
  def downloadData
    @@data = open(@@url)
  end
  
  def findData(html_start, html_stop, regex)
    text = @@data.read; nil
    start = text.index(html_start)
    stop = text.index(html_stop, start)
    restricted_text = text[start..stop]
    nested_stats = restricted_text.scan(regex)
    # important line - removes nested arrays
    return nested_stats.flatten.uniq
  end

#======================================================================  
  # URL
#======================================================================
  def getUrl
    return @@url
  end

  def setUrl(url)
    @@url = url
  end
end
