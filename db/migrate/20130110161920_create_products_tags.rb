class CreateProductsTags < ActiveRecord::Migration[7.2]
  def change
    create_table :products_tags, id: false do |t|
      t.integer :tag_id, null: false
      t.integer :product_id, null: false
    end

    add_index :products_tags, :tag_id
    add_index :products_tags, :product_id
  end
end
