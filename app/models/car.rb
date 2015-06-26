class Car < ActiveRecord::Base


	def is_good?
		self.edmunds_price.to_i - self.cl_price.to_i > 500
	end
end