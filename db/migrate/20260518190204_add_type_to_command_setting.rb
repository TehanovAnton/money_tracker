class AddTypeToCommandSetting < ActiveRecord::Migration[7.0]
  def change
    add_column :command_settings, :type, :string
  end
end
