require_relative 'scraper'
# require 'nokogiri'
# require 'uri'
# require 'net/http'
require 'json'
class Edmunds
	attr_reader :api_key, :prefix, :attr_hash, :year, :make, :model

	def initialize(args={})
		@attr_hash = args.fetch(:attr_hash, nil)
		@year = args.fetch(:year, nil)
		@make = args.fetch(:make, nil)
		@model = args.fetch(:model, nil)
		@api_key = API_KEY
		@prefix = "http://api.edmunds.com/api/vehicle/v2/"
	end

	def get_category
		cat = attr_hash[:type]
		if cat.match(" ")
			cat.gsub("+").to_s
		else
			cat
		end
	end

	def build_query_string
		p "#{prefix}#{make}/#{model}/#{year}/styles?state=used&category=#{get_category}&view=full&fmt=json&api_key=#{api_key}"
	end

	def query_api
		parsed_url = URI.parse(build_query_string)
		response = Net::HTTP.new(parsed_url.host, parsed_url.port)
		req = Net::HTTP::Get.new(parsed_url.request_uri)
		response.request(req)
	end

	def hashize
		p JSON.parse(query_api.body)
	end

	def find_price
		puts "*************** #{attr_hash.inspect}"
		puts "#{year} #{make} #{model}"
		my_trans_type = attr_hash[:transmission].upcase
		hashize["styles"].each do |style|
			if style["transmission"]["transmissionType"] == my_trans_type
				return style["price"]["usedPrivateParty"]
			end
		end
	end

	def car_title
		"#{year} #{make} #{model}"
	end

end
