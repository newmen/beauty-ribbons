class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :identifier, null: false
      t.string :title, null: false
      t.text :markdown, null: false

      t.timestamps
    end

    add_index :pages, :identifier, unique: true
  end
end
