# frozen_string_literal: true

require_relative 'abstract_factory'

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module AbstractFactories
          class ConcreteFactory < AbstractFactory
            def execute; end

            def log_factory_creation(factory_type, factory_name)
              Rails.logger.debug "[ConcreteFactory] Creating #{factory_type} for: #{factory_name}"
            end

            def input_parser_factory(factory_name)
              Telegram::Messages::Layouts::Spreadsheets::Parsers::InputParserFactory.run!(
                factory_name: factory_name, style: :initializer
              )
            end

            def text_preparation_factory(factory_name)
              Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparationFactory.run!(
                factory_name: factory_name, style: :initializer
              )
            end

            def layout_params_factory(factory_name, parsed_input)
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsFactory.run!(
                factory_name: factory_name, style: :initializer
              ).tap do |lp|
                lp.params = parsed_input
              end
            end
          end
        end
      end
    end
  end
end
