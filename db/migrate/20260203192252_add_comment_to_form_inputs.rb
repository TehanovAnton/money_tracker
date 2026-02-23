class AddCommentToFormInputs < ActiveRecord::Migration[7.0]
  def change
    add_column :form_inputs, :comment, :string
  end
end
