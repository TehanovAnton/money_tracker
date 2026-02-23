class AddRangeToFormInputs < ActiveRecord::Migration[7.0]
  def change
    add_column :form_inputs, :range, :string
  end
end
