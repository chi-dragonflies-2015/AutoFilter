require 'nokogiri'
require 'uri'
require 'net/http'
class Scraper
  def scrape(url)
    Net::HTTP.get_response(URI.parse(url))
  end

end


output = Scraper.new.scrape("https://chicago.craigslist.org/chc/cto/5091329016.html")
puts output.inspect

