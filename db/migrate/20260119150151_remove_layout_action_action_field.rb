class RemoveLayoutActionActionField < ActiveRecord::Migration[7.0]
  def change
    remove_column :layout_actions, :action
  end
end
