# frozen_string_literal: true

class User < ApplicationRecord
  has_one :chat_context,
          -> { order(updated_at: :desc) },
          dependent: :destroy,
          inverse_of: :user
  has_one :layout_cursor_action,
          class_name: 'LayoutAction',
          dependent: :destroy
  has_many :spreadsheets, dependent: :nullify

  has_one :add_expense_command_setting, -> { where(type: 'AddExpenseCommandSetting') }, dependent: nil,
                                                                                        inverse_of: :user
  has_one :add_expense_saved_input, through: :add_expense_command_setting, source: :savable_input,
                                    source_type: 'AddExpenseSavedInput'
end
