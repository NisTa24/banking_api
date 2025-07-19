class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts, id: false do |t|
      t.uuid :id, primary_key: true, null: false
      t.decimal :balance, precision: 15, scale: 2, default: 0.0, null: false

      t.timestamps
    end
  end
end
