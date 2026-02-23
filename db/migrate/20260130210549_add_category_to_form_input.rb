class AddCategoryToFormInput < ActiveRecord::Migration[7.0]
  def change
    add_column :form_inputs, :category, :string
  end
end
