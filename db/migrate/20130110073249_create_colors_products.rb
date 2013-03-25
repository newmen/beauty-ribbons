class CreateColorsProducts < ActiveRecord::Migration
  def change
    create_table :colors_products, id: false do |t|
      t.integer :color_id, :product_id, null: false
    end

    add_index :colors_products, :color_id
    add_index :colors_products, :product_id
  end
end
