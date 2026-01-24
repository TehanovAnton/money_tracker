# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module IDefineFactory
          def define(factory_name, *inline_options, **named_options)
            config[:factories][factory_name] = yield

            config[:options][factory_name] ||= {}
            config[:options][factory_name][:inline_options] = inline_options
            config[:options][factory_name][:named_options] = named_options
          end

          def config
            @config ||= { factories: {}, options: {} }
          end
        end

        class BaseFactory < ActiveInteraction::Base
          extend IDefineFactory

          symbol :factory_name

          def execute
            config[:factories][factory_name]
          end

          private

          def config
            self.class.config
          end
        end
      end
    end
  end
end
