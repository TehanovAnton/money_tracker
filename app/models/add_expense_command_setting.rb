# frozen_string_literal: true

class AddExpenseCommandSetting < CommandSetting
  belongs_to :user, inverse_of: :add_expense_command_setting
end
