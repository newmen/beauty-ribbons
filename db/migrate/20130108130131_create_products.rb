class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :slug, null: false
      t.integer :category_id
      t.integer :cover_id, null: false
      t.string :name, null: false
      t.text :description
      t.integer :width
      t.integer :height
      t.integer :length
      t.integer :diameter
      t.integer :price_cents, null: false
      t.integer :old_price_cents
      t.integer :badge_id
      t.boolean :is_archived, default: false

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, [:category_id, :slug], unique: true
  end
end
