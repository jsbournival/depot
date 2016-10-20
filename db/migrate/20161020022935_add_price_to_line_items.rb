class AddPriceToLineItems < ActiveRecord::Migration[5.0]
  def change
  	add_column :line_items, :price, :float, default: 0.0
  end
end
