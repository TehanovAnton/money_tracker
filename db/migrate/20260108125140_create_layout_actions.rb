class CreateLayoutActions < ActiveRecord::Migration[7.0]
  def change
    create_table :layout_actions do |t|
      t.string :layout, null: false
      t.string :action, null: false
      t.bigint :user_id, null: false

      t.timestamps
    end
  end
end
