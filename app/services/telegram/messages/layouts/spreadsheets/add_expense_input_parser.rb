# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        TextPreparation = Struct.new(:text, :clean_white_space) do
          def prepared_text
            return text unless clean_white_space

            text.gsub(/\s/, '')
          end
        end

        class InputParserFactory < BaseFactory
          define(:enter_date, value_alias: :date, kind: :date_input) do
            Telegram::AddExpenseInputParser
          end

          define(:enter_money, value_alias: :money, kind: :money_input) do
            Telegram::AddExpenseInputParser
          end

          define(:enter_money, value_alias: :money, kind: :money_input) do
            Telegram::AddExpenseInputParser
          end

          define(:enter_category, value_alias: :category, kind: :category_input) do
            Telegram::AddExpenseInputParser
          end

          define(:enter_comment, value_alias: :comment, kind: :comment_input) do
            Telegram::AddExpenseInputParser
          end
        end

        class TextPreparationFactory < BaseFactory
          define(:enter_date, clean_white_space: true) do
            TextPreparation
          end

          define(:enter_money, clean_white_space: true) do
            TextPreparation
          end

          define(:enter_category, clean_white_space: false) do
            TextPreparation
          end

          define(:enter_comment, clean_white_space: false) do
            TextPreparation
          end
        end

        class LayoutParamsBuilder
          attr_reader :with_layout_params, :layout_params
          attr_accessor :params

          def initialize(with_layout_params)
            @with_layout_params = with_layout_params
            @layout_params = {}
            @params = nil
          end

          def build
            with_layout_params.each { |layout_param| add_layout_param(layout_param) }
            self
          end

          private

          def add_layout_param(layout_param)
            layout_params[layout_param[:name]] = params.fetch(
              layout_param[:name],
              layout_param[:default_value] || nil
            )
          end
        end

        class LayoutParamsFactory < BaseFactory
          define(:enter_date, [{ name: :action_number }, { name: :date }]) do
            LayoutParamsBuilder
          end

          define(:enter_money, [{ name: :action_number }, { name: :money }]) do
            LayoutParamsBuilder
          end

          define(:enter_category, [{ name: :action_number }, { name: :category }]) do
            LayoutParamsBuilder
          end

          define(:enter_comment, [{ name: :action_number }, { name: :comment }]) do
            LayoutParamsBuilder
          end
        end

        class AddExpenseInputParser < InputParserBase
          string :text

          def execute
            action_name
            layout_params
          end

          private

          def action_name
            @action_name ||= action_name_for
          end

          def action_name_for
            action_number = text.split(')').first.to_i
            AddExpenseLayout.action_name_for(action_number)
          end

          def layout_params
            layout_params_factory(action_name, parsed_input)
              .build
              .layout_params
          end

          def parsed_input
            parse(
              input_parser_factory(action_name),
              text_preparation_factory(action_name).prepared_text
            ) || {}
          end

          def input_parser(value_alias, **options)
            Telegram::AddExpenseInputParser.new(value_alias, **options)
          end

          def parse(parser, txt)
            parser.parse(txt).transform_values(&:to_s)
          rescue Parslet::ParseFailed
            nil
          end

          def input_parser_factory(factory_name)
            InputParserFactory.run!(factory_name: factory_name, style: :initializer)
          end

          def text_preparation_factory(factory_name)
            TextPreparationFactory.run!(factory_name: factory_name, style: :initializer).tap do |tp|
              tp.text = text
            end
          end

          def layout_params_factory(factory_name, parsed_input)
            LayoutParamsFactory.run!(factory_name: factory_name, style: :initializer).tap do |lp|
              lp.params = parsed_input
            end
          end
        end
      end
    end
  end
end
