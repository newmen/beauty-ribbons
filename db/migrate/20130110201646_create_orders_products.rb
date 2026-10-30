class CreateOrdersProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :orders_products, id: false do |t|
      t.integer :order_id, null: false
      t.integer :product_id, null: false
    end

    add_index :orders_products, :order_id
  end
end
