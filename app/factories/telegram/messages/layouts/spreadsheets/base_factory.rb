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

          STYLES = %i[const_keeper initializer danger_runner].freeze

          symbol :factory_name
          symbol :style, default: :const_keeper
          hash :additional_named_options, strip: false, default: nil

          def execute
            case style
            when :const_keeper
              factorable
            when :initializer
              factorable.new(*inline_options, **named_options)
            when :danger_runner
              factorable.run!(*inline_options, **named_options)
            end
          end

          private

          def factorable
            config[:factories][factory_name]
          end

          def inline_options
            config[:options][factory_name][:inline_options]
          end

          def named_options
            options = \
              if additional_named_options.present?
                defined_namdde_options.merge(additional_named_options)
              else
                defined_namdde_options
              end

            options.transform_keys(&:to_sym)
          end

          def defined_namdde_options
            config[:options][factory_name][:named_options]
          end

          def config
            self.class.config
          end
        end
      end
    end
  end
end
