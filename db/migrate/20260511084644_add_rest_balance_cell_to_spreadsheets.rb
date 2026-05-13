class AddRestBalanceCellToSpreadsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :spreadsheets, :rest_balance_cell, :string
  end
end
