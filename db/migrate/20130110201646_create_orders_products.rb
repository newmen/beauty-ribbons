class CreateOrdersProducts < ActiveRecord::Migration
  def change
    create_table :orders_products, id: false do |t|
      t.integer :order_id, :product_id, null: false
    end

    add_index :orders_products, :order_id
  end
end
