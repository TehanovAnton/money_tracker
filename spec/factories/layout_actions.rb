# frozen_string_literal: true

FactoryBot.define do
  factory :layout_action do
    association :user
    layout { Telegram::Messages::Layouts::Spreadsheets::Index.name }
  end
end
