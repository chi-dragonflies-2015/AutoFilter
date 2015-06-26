require 'nokogiri'
require 'uri'
require 'net/http'
class Scraper
  attr_reader :attr_hash, :ymm, :price

  def initialize(url)
    @url = url
    @noko = nil
    @attrs_inner_text = nil
    @attr_hash = {}
    @ymm = nil
    @price = nil
  end

  def grab
    Net::HTTP.get_response(URI.parse(@url)).body
  end

  def parse(html)
    Nokogiri::HTML(html)
  end

  def find_attrs(noko)
    noko.search(".mapAndAttrs .attrgroup span")
  end

  def find_price(noko)
    noko.search(".price")
  end

  def get_inner_text(noko)
    noko.map{|elem| elem.inner_text}
  end

  def is_pair(string)
    string.match(": ")
  end

  def get_ymm(string)
    string.split(" ")
  end

  def build_hash(attr_array)
    attr_array.each do |string|
      if is_pair(string)
        key_value = string.split(": ")
        @attr_hash[key_value[0].to_sym] = key_value[1]
      else
        @ymm = get_ymm(string)
      end
    end
  end

  def run_scraper
    @noko = parse(grab)
    @attrs_inner_text = get_inner_text(find_attrs(@noko))
    build_hash(@attrs_inner_text)
    @price = get_inner_text(find_price(@noko))[0].gsub("$","")
  end

  def output_hash
    run_scraper
    {attr_hash: attr_hash, year: ymm[0], make: ymm[1], model: ymm[2], price: price}
  end

end
