class CreateProductImages < ActiveRecord::Migration[7.2]
  def change
    create_table :product_images do |t|
      t.integer :product_id
      t.string :image, null: false
    end
  end
end
