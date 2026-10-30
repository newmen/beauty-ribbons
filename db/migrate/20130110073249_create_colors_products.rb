class CreateColorsProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :colors_products, id: false do |t|
      t.integer :color_id, null: false
      t.integer :product_id, null: false
    end

    add_index :colors_products, :color_id
    add_index :colors_products, :product_id
  end
end
