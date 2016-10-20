class CopyPriceToLineItems < ActiveRecord::Migration[5.0]
  def change
	# Single item
	Cart.all.each do |cart|
	  cart.line_items.each do |line_item|
	  	
		line_item.price = line_item.product.price
		line_item.save!

	  end
	end	  	
  end
end
