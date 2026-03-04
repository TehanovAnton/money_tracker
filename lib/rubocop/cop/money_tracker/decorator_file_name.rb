# frozen_string_literal: true

module RuboCop
  module Cop
    module MoneyTracker
      class DecoratorFileName < Base
        MSG = 'Decorator files in app/decorators must end with _decorator.rb.'
        TARGET_DIRECTORY_PATTERN = %r{(?:\A|/)app/decorators/}
        REQUIRED_SUFFIX = '_decorator.rb'

        def on_new_investigation
          super
          return unless inside_target_directory?
          return if valid_file_name?

          add_offense(offense_range, message: MSG)
        end

        private

        def inside_target_directory?
          normalized_file_path.match?(TARGET_DIRECTORY_PATTERN)
        end

        def valid_file_name?
          File.basename(normalized_file_path).end_with?(REQUIRED_SUFFIX)
        end

        def normalized_file_path
          @normalized_file_path ||= processed_source.file_path.to_s.delete_prefix('./')
        end

        def offense_range
          processed_source.ast&.loc&.expression || source_range(processed_source.buffer, 0, 0)
        end
      end
    end
  end
end
