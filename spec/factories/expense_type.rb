# frozen_string_literal: true

FactoryBot.define do
  factory :expense_type, class: 'Telegram::Commands::Spreadsheets::ExpenseType' do
    skip_create
    initialize_with { new(attributes) }

    date     { Date.current.to_s }
    amount   { BigDecimal('100.00').to_s }
    category { 'Продукты' }
    comment  { nil }
  end
end
