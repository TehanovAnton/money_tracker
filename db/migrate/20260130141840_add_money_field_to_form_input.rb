class AddMoneyFieldToFormInput < ActiveRecord::Migration[7.0]
  def change
    add_column :form_inputs, :money, :decimal, precision: 6, scale: 2
  end
end
