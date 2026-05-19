class CreateCommandSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :command_settings do |t|
      t.bigint :user_id
      t.string :savable_input_type
      t.bigint :savable_input_id

      t.timestamps
    end
  end
end
