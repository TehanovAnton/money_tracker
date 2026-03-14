# frozen_string_literal: true

require_relative 'naming_base'

module RuboCop
  module Cop
    module MoneyTracker
      class FolderNamingBase < NamingBase
        def on_new_investigation
          super
          return unless target_folder_for_current_cop
          return unless configured_singular_name
          return unless (invalid_directory = invalid_directory_for_current_file)

          add_global_offense(
            format(
              folder_message,
              directory: invalid_directory,
              suffix: forbidden_suffix,
              singular: configured_singular_name
            )
          )
        end

        private

        def invalid_directory_for_current_file
          return unless path_inside_target_directory?

          current_path_parts = ['app', target_folder_for_current_cop]
          path_parts_inside_target.each do |part|
            current_path_parts << part
            return current_path_parts.join('/') if invalid_folder_part?(part)
          end

          nil
        end

        def invalid_folder_part?(part)
          part.end_with?(forbidden_suffix) || part.include?(configured_singular_name)
        end

        def forbidden_suffix
          target_folder_for_current_cop
        end

        def folder_message
          'Directory `%<directory>s` must not end with `%<suffix>s` or include `%<singular>s`.'
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
