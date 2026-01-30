# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class AddExpenseLayout < Base
          integer :spreadsheet_id, default: nil
          string :date, default: nil
          float :money, default: nil

          define_action(:list_all_actions, 'Доступные действия')
          define_action(:enter_date, 'Ввести дату')
          define_action(:enter_money, 'Ввести сумму')

          private

          def enter_date
            return messages << 'Пустая дата' unless date

            date_input
            messages << 'Дата введена'
            list_all_actions
            messages.flatten!
          end

          def enter_money
            return messages << 'Пустая сумма' unless money

            money_input
            messages << 'Сумма введена'
            list_all_actions
            messages.flatten!
          end

          def spreadsheet_form
            @spreadsheet_form ||= SpreadsheetForm.find_or_create_by(user: user, spreadsheet_id: spreadsheet_id)
          end

          def date_input
            @date_input ||= DateFormInput.create(form_id: spreadsheet_form.id, date: date)
          end

          def money_input
            @money_input ||= MoneyFormInput.create(form_id: spreadsheet_form.id, money: money)
          end
        end
      end
    end
  end
end
