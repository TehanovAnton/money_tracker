# frozen_string_literal: true

FactoryBot.define do
  factory :spreadsheet do
    document_id { 'jnkjbjkjhgfg' }
    expense_range { 'Sheet1!A1:B1' }
    association :user
  end
end
