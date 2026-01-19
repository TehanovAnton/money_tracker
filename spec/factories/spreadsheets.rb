# frozen_string_literal: true

FactoryBot.define do
  factory :spreadsheet do
    spreadsheet_id { 'jnkjbjkjhgfg' }
    association :user
  end
end
