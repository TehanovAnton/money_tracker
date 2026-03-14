# frozen_string_literal: true

FactoryBot.define do
  factory :layout_action do
    association :user
    layout { Telegram::MessageLayouts::IndexService.name }
  end
end
