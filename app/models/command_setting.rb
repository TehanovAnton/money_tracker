# frozen_string_literal: true

class CommandSetting < ApplicationRecord
  belongs_to :user
  belongs_to :savable_input, polymorphic: true, optional: true
end
