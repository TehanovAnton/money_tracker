# frozen_string_literal: true

require_relative 'naming_base'

module RuboCop
  module Cop
    module MoneyTracker
      class FileNameBase < NamingBase
        def on_new_investigation
          super
          return unless target_folder_for_current_cop
          return unless configured_singular_name
          return if valid_file_name?

          add_offense(offense_range, message: file_name_message)
        end

        private

        def valid_file_name?
          File.basename(normalized_file_path).end_with?(required_suffix)
        end

        def required_suffix
          "_#{configured_singular_name}.rb"
        end

        def file_name_message
          "Files in app/#{current_app_folder} must end with #{required_suffix}."
        end

        def offense_range
          processed_source.ast&.loc&.expression || source_range(processed_source.buffer, 0, 0)
        end

        def target_folder_for_current_cop
          return unless current_app_folder

          class_target_folder = self.class::TARGET_FOLDER if self.class.const_defined?(:TARGET_FOLDER, false)
          return class_target_folder if class_target_folder && class_target_folder == current_app_folder

          current_app_folder unless class_target_folder
        end
      end
    end
  end
end
