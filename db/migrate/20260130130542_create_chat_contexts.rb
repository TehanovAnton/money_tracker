class CreateChatContexts < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_contexts do |t|
      t.bigint :user_id, null: false
      t.bigint :spreadsheet_id

      t.timestamps
    end
  end
end
