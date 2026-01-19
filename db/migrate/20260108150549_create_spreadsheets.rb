class CreateSpreadsheets < ActiveRecord::Migration[7.0]
  def change
    create_table :spreadsheets do |t|
      t.string :spreadsheet_id, null: false
      t.bigint :user_id, null: false

      t.timestamps
    end
  end
end
