class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :type, null: false
      t.string :username, null: false
      t.string :email, null: false
      t.string :zipcode
      t.string :country
      t.string :region
      t.string :city
      t.string :street_line
      t.text :comment
      t.text :note
      t.string :state, null: false
      t.integer :expected_cost_cents
      t.integer :amount_cents

      t.timestamps
    end

    add_index :orders, :type
  end
end
