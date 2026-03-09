# frozen_string_literal: true

require_relative 'naming_base'

module RuboCop
  module Cop
    module MoneyTracker
      class FolderNamingBase < NamingBase
        exclude_from_registry

        def on_new_investigation
          super
          return unless (invalid_directory = invalid_directory_for_current_file)

          add_global_offense(
            format(
              folder_message,
              directory: invalid_directory,
              suffix: forbidden_suffix,
              singular: target_singular
            )
          )
        end

        private

        def invalid_directory_for_current_file
          return unless path_inside_target_directory?

          current_path_parts = target_root_directory.split('/')
          path_parts_inside_target.each do |part|
            current_path_parts << part
            return current_path_parts.join('/') if invalid_folder_part?(part)
          end

          nil
        end

        def invalid_folder_part?(part)
          part.end_with?(forbidden_suffix) || part.include?(target_singular)
        end

        def forbidden_suffix
          target_folder
        end

        def folder_message
          'Directory `%<directory>s` must not end with `%<suffix>s` or include `%<singular>s`.'
        end
      end
    end
  end
end
