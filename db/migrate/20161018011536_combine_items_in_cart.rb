class CombineItemsInCart < ActiveRecord::Migration[5.0]

	def up
		# Single item
		Cart.all.each do |cart|

			# count the number of each product in the cart
			sums = cart.line_items.group(:product_id).sum(:quantity)
			sums.each do |product_id, quantity|
				
				if quantity > 1
			
					# replace with a single item, and set its quantity
					cart.line_items.where(product_id: product_id).delete_all
					item = cart.line_items.build(product_id: product_id)
					item.quantity = quantity
					item.save!
				end
			end
		end	
	end

	def down

		LineItem.where("quantity > 1").each do |line_item|
			line_item.quantity.times do
				LineItem.create(cart_id: line_item.cart_id, product_id: line_item.product_id, quantity: 1)
			end
			line_item.destroy
		end
	end
	
end
