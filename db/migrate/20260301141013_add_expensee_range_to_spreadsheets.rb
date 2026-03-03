class AddExpenseeRangeToSpreadsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :spreadsheets, :expense_range, :string
  end
end
