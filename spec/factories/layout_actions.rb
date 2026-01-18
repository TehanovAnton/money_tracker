# frozen_string_literal: true

FactoryBot.define do
  factory :layout_action do
    association :user
    layout { Telegram::Messages::Layouts::Spreadsheets::Index.name }
    action { Telegram::Messages::Layouts::Spreadsheets::Index::AVAILABLE_ACTIONS.keys.first }
  end
end
