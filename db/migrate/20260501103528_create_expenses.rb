class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.bigint :spreadsheet_id, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :date, null: false
      t.string :category, null: false
      t.text :comment

      t.timestamps
    end
  end
end
