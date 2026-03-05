# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class BaseParser < ActiveInteraction::Base
      string :text
      string :layout_klass, default: nil

      DEFAULT_ABSTRACT_FACTORY = Factories::DefaultLayoutFactory
      ABSTRACT_FACTORY_BY_LAYOUT = {
        'Telegram::MessageLayouts::NewService' =>
          Factories::NewLayoutFactory,
        'Telegram::MessageLayouts::ListTablesService' =>
          Factories::ListTablesLayoutFactory,
        'Telegram::MessageLayouts::AddExpenseLayoutService' =>
          Factories::AddExpenseLayoutFactory
      }.freeze

      def execute
        action_name
        layout_params
      end

      private

      def action_number
        text.split(')').first.to_i
      end

      def layout
        @layout ||= layout_klass&.safe_constantize
      end

      def layout_params
        layout_params_builder(builder_name: layout_params_builder_name, layout_params: parsed_input)
          .build
          .layout_params
      end

      def layout_params_builder(builder_name:, layout_params:)
        factory.layout_params_factory(builder_name, layout_params)
      end

      def parse(parser, txt)
        parser.parse(txt).transform_values(&:to_s)
      rescue Parslet::ParseFailed
        nil
      end

      def text_preparation(preparation_name:)
        factory.text_preparation_factory(preparation_name, text)
      end

      def factory
        @factory ||= abstract_factory_for_layout.run
      end

      def abstract_factory_for_layout
        ABSTRACT_FACTORY_BY_LAYOUT.fetch(layout&.name, DEFAULT_ABSTRACT_FACTORY)
      end

      def layout_params_builder_name
        raise NotImplementedError, 'Subclasses must implement layout_params_builder_name'
      end

      def parsed_input
        raise NotImplementedError, 'Subclasses must implement parsed_input'
      end

      def action_name
        raise NotImplementedError, 'Subclasses must implement action_name'
      end

      def input_parser
        raise NotImplementedError, 'Subclasses must implement input_parser'
      end
    end
  end
end
