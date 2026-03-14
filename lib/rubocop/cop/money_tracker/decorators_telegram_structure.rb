# frozen_string_literal: true

module RuboCop
  module Cop
    module MoneyTracker
      class DecoratorsTelegramStructure < Base
        MSG = 'Directory app/decorators/telegram must exist.'
        REQUIRED_DIRECTORY = File.join('app', 'decorators', 'telegram')

        def self.support_multiple_source?
          true
        end

        def on_new_investigation
          super
          return if @checked

          @checked = true
          return if required_directory_exists?

          add_global_offense(MSG)
        end

        def external_dependency_checksum
          required_directory_exists?.to_s
        end

        private

        def required_directory_exists?
          File.directory?(required_directory_path)
        end

        def required_directory_path
          File.join(Dir.pwd, REQUIRED_DIRECTORY)
        end
      end
    end
  end
end
