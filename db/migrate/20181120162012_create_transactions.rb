class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :symbol, null: false
      t.integer :quantity, null: false
      t.float :share_price, null: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
