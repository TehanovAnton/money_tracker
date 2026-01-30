# frozen_string_literal: true

FactoryBot.define do
  factory :chat_context do
    association :user
    spreadsheet_id {}
  end
end
