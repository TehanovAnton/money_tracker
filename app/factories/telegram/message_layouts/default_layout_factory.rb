# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class DefaultLayoutFactory < ::Abstract::AbstractFactory
      def execute; end

      def input_parser_factory(factory_name)
        Telegram::MessageLayouts::DefaultLayoutInputParserFactory.run!(
          factory_name: factory_name, style: :initializer
        )
      end

      def text_preparation_factory(factory_name, text)
        Telegram::MessageLayouts::DefaultLayoutTextPreparationFactory.run!(
          factory_name: factory_name,
          additional_named_options: { text: text },
          style: :initializer
        )
      end

      def layout_params_factory(factory_name, parsed_input)
        Telegram::MessageLayouts::DefaultLayoutParamsFactory.run!(
          factory_name: factory_name,
          additional_named_options: { params: parsed_input },
          style: :initializer
        )
      end
    end
  end
end
