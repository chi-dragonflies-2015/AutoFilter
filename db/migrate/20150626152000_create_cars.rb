class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :title, :edmunds_price, :cl_price
      t.timestamps
    end
  end
end
