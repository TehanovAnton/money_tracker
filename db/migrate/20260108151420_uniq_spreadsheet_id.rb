class UniqSpreadsheetId < ActiveRecord::Migration[7.0]
  def change
    add_index :spreadsheets, :document_id, unique: true
  end
end
