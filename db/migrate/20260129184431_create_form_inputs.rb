class CreateFormInputs < ActiveRecord::Migration[7.0]
  def change
    create_table :form_inputs do |t|
      t.bigint :form_id, null: false
      t.string :type, null: false
      t.string :date

      t.timestamps
    end
  end
end
