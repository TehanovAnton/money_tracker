# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class DeleteService < BaseService
      string :document_id, default: nil

      define_action(:enter_spreadsheets_params, 'Удалить')

      private

      def enter_spreadsheets_params
        unless valid_spreadsheets_params?
          messages << 'Невалидные данные таблицы'
          return handle_messages do
            layouts_factory(layout_name: :list_tables).run!(bot: bot, user: user, action_name: :list_all_actions)
          end
        end

        spreadsheet.destroy
        messages << 'Таблица удалена'

        messages << layouts_factory(layout_name: :index)
                    .run!(bot: bot, user: user, action_name: :list_all_actions)
        messages.flatten!
      end

      def valid_spreadsheets_params?
        normalized_document_id.present? && spreadsheet.present?
      end

      def spreadsheet
        Spreadsheet.find_by(document_id: normalized_document_id)
      end

      def normalized_document_id
        @normalized_document_id ||= parse_document_id(document_id)
      end

      def parse_document_id(raw_document_id)
        return raw_document_id if raw_document_id.blank?

        normalized_document_id = raw_document_id.strip
        named_parameter_match = normalized_document_id.match(/\A(?:--|—|–)document_id\s*(.+)\z/)
        return normalized_document_id unless named_parameter_match

        unquote_document_id(named_parameter_match[1].strip)
      end

      def unquote_document_id(raw_document_id)
        return raw_document_id[1..-2] if raw_document_id.start_with?('"') && raw_document_id.end_with?('"')
        return raw_document_id[1..-2] if raw_document_id.start_with?("'") && raw_document_id.end_with?("'")

        raw_document_id
      end
    end
  end
end
