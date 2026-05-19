# frozen_string_literal: true

class AddExpenseSavedInput < ApplicationRecord
  has_one :command_setting, as: :savable_input, dependent: nil
end
