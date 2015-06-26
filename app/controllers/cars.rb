post "/cars" do
	scraper = Scraper.new(params[:url])
	edmunds = Edmunds.new(scraper.output_hash)
	Car.create(title: edmunds.car_title, cl_price: scraper.price, edmunds_price: edmunds.get_price)
	@cars = Car.order(created_at: :desc)
	erb :"cars/show"


	# content_type :json
	# {title: edmunds.car_title, cl_price: scraper.price, edmunds_price: edmunds.get_price}.to_json
end