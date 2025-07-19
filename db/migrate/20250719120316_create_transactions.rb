class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions, id: false do |t|
      t.uuid :id, primary_key: true, null: false
      t.uuid :from_account_id, null: false
      t.uuid :to_account_id, null: false
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.timestamps
    end

    add_foreign_key :transactions, :accounts, column: :from_account_id, primary_key: :id
    add_foreign_key :transactions, :accounts, column: :to_account_id, primary_key: :id

    add_check_constraint :transactions, "amount > 0", name: "positive_amount"
    add_check_constraint :transactions, "from_account_id != to_account_id", name: "different_accounts"

    add_index :transactions, :id, unique: true
    add_index :transactions, :from_account_id
    add_index :transactions, :to_account_id
  end
end
