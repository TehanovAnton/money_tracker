# frozen_string_literal: true

require_relative 'naming_base'

module RuboCop
  module Cop
    module MoneyTracker
      class FileNameBase < NamingBase
        exclude_from_registry

        def on_new_investigation
          super
          return unless path_inside_target_directory?
          return if valid_file_name?

          add_offense(offense_range, message: file_name_message)
        end

        private

        def valid_file_name?
          File.basename(normalized_file_path).end_with?(required_suffix)
        end

        def required_suffix
          "_#{target_singular}.rb"
        end

        def file_name_message
          "Files in #{target_root_directory} must end with #{required_suffix}."
        end

        def offense_range
          processed_source.ast&.loc&.expression || source_range(processed_source.buffer, 0, 0)
        end
      end
    end
  end
end
