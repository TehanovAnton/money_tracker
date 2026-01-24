# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module IDefineLayoutFactory
          def define(layout_name, *layout_inline_options, **layout_named_options)
            config[:layouts][layout_name] = yield

            config[:options][layout_name] ||= {}
            config[:options][layout_name][:inline_options] = layout_inline_options
            config[:options][layout_name][:named_options] = layout_named_options
          end

          def config
            @config ||= { layouts: {}, options: {} }
          end
        end

        class LayoutsFactory < ActiveInteraction::Base
          extend IDefineLayoutFactory

          symbol :layout_name

          define(:index) do
            Index
          end

          define(:new) do
            New
          end

          define(:delete) do
            Delete
          end

          define(:list_tables) do
            ListTables
          end

          def execute
            config[:layouts][layout_name]
          end

          private

          def config
            LayoutsFactory.config
          end
        end
      end
    end
  end
end
