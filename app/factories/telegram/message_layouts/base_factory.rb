# frozen_string_literal: true

module Telegram
  module MessageLayouts
        module IDefineFactory
          def define(factory_name, *inline_options, **named_options)
            config[:factories][factory_name] = yield

            config[:options][factory_name] ||= {}
            config[:options][factory_name][:inline_options] = inline_options
            config[:options][factory_name][:named_options] = named_options
          end

          def multi_define(*factory_names, **factory_options)
            factorable = yield

            factory_names.each do |factory_name|
              inline_options = factory_options[factory_name]&.fetch(:inline_options, []) || []
              named_options = factory_options[factory_name]&.fetch(:named_options, {}) || {}
              define(factory_name, *inline_options, **named_options) { factorable }
            end
          end

          def config
            @config ||= { factories: {}, options: {} }
          end
        end

        class BaseFactory < ActiveInteraction::Base
          class UnknonwnFactoryError < StandardError; end

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
            unless config[:options][factory_name]
              raise UnknonwnFactoryError,
                    "#{factory_name} is not defined in #{self.class}. Available factories - #{config[:options].keys}"
            end

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
