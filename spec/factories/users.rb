# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    telegram_username { 'best_user' }

    trait :with_layout_cursor_action do
      after(:create) do |user, _|
        user.update(layout_cursor_action: FactoryBot.create(:layout_action))
        user.reload
      end
    end
  end
end
