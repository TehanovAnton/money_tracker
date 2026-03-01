# frozen_string_literal: true

require_relative 'abstract_factory'

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class NewLayoutFactory < AbstractFactory
            def execute; end

            def input_parser_factory(factory_name)
              Telegram::Messages::Layouts::Spreadsheets::Factories::NewLayoutInputParserFactory.run!(
                factory_name: factory_name, style: :initializer
              )
            end

            def text_preparation_factory(factory_name, text)
              Telegram::Messages::Layouts::Spreadsheets::Factories::NewLayoutTextPreparationFactory.run!(
                factory_name: factory_name,
                additional_named_options: { text: text },
                style: :initializer
              )
            end

            def layout_params_factory(factory_name, parsed_input)
              Telegram::Messages::Layouts::Spreadsheets::Factories::NewLayoutParamsFactory.run!(
                factory_name: factory_name,
                additional_named_options: { params: parsed_input },
                style: :initializer
              )
            end
          end
        end
      end
    end
  end
end
