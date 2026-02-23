# frozen_string_literal: true

FactoryBot.define do
  factory :spreadsheet do
    document_id { 'jnkjbjkjhgfg' }
    association :user
  end
end
