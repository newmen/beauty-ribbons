class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string :name, null: false
      t.string :value, null: false, limit: 6

      t.timestamps
    end
  end
end
