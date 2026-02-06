# frozen_string_literal: true

require 'active_interaction'

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module AbstractFactories
          # Абстрактная фабрика для создания парсеров и обработчиков ввода
          class AbstractFactory < ActiveInteraction::Base
            string :factory_name
            hash :parsed_input, default: {}

            private

            def input_parser_factory(factory_name)
              raise NotImplementedError, 'Subclasses must implement input_parser_factory'
            end

            def text_preparation_factory(factory_name)
              raise NotImplementedError, 'Subclasses must implement text_preparation_factory'
            end

            def layout_params_factory(factory_name, parsed_input)
              raise NotImplementedError, 'Subclasses must implement layout_params_factory'
            end

            def log_factory_creation(factory_type, factory_name)
              Rails.logger.debug "[AbstractFactory] Creating #{factory_type} for: #{factory_name}"
            end
          end
        end
      end
    end
  end
end