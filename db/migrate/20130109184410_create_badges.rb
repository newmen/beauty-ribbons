class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :identifier, limit: 4
      t.string :name, null: false
      t.string :color, null: false, limit: 6
      t.integer :position, default: 0

      t.timestamps
    end

    add_index :badges, :identifier, unique: true
  end
end
