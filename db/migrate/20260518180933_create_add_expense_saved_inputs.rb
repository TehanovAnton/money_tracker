class CreateAddExpenseSavedInputs < ActiveRecord::Migration[7.0]
  def change
    create_table :add_expense_saved_inputs do |t|
      t.string :document_id, null: true
      t.string :date, null: true
      t.string :amount, precision: 10, scale: 2, null: true
      t.string :category, null: true
      t.text :comment, null: true

      t.timestamps
    end
  end
end
