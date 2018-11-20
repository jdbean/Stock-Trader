class CreatePositions < ActiveRecord::Migration[5.2]
  def change
    create_table :positions do |t|
      t.belongs_to :user
      t.string :symbol, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
