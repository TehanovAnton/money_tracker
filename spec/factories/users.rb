# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    telegram_username { 'best_user' }

    trait :with_layout_cursor_action do
      transient do
        layout { Telegram::Messages::Layouts::Spreadsheets::Index.name }
      end

      after(:create) do |user, evaluator|
        user.update(
          layout_cursor_action: FactoryBot.create(:layout_action, layout: evaluator.layout)
        )
        user.reload
      end
    end
  end
end
