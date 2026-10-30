class CreatePageImages < ActiveRecord::Migration[7.2]
  def change
    create_table :page_images do |t|
      t.integer :page_id
      t.string :image, null: false
    end
  end
end
