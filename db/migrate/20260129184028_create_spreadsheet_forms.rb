class CreateSpreadsheetForms < ActiveRecord::Migration[7.0]
  def change
    create_table :spreadsheet_forms do |t|
      t.bigint :spreadsheet_id, null: false
      t.bigint :user_id, null: false

      t.timestamps
    end
  end
end
