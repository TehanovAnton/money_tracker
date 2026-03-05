# frozen_string_literal: true

module RuboCop
  module Cop
    module MoneyTracker
      class NamingBase < Base
        exclude_from_registry

        private

        def target_folder
          self.class::TARGET_FOLDER
        end

        def target_root_directory
          @target_root_directory ||= "app/#{target_folder}"
        end

        def singular_target
          @singular_target ||= target_folder.sub(/s\z/, '')
        end

        def normalized_file_path
          @normalized_file_path ||= processed_source.file_path.to_s.delete_prefix('./').tr('\\', '/')
        end

        def path_inside_target_directory?
          normalized_file_path.match?(%r{(?:\A|/)#{Regexp.escape(target_root_directory)}/})
        end

        def path_parts_inside_target
          path_in_root = normalized_file_path.split(%r{#{Regexp.escape(target_root_directory)}/}, 2).last
          return [] unless path_in_root

          path_in_root.split('/')[0...-1]
        end
      end

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
          "_#{singular_target}.rb"
        end

        def file_name_message
          "Files in #{target_root_directory} must end with #{required_suffix}."
        end

        def offense_range
          processed_source.ast&.loc&.expression || source_range(processed_source.buffer, 0, 0)
        end
      end

      class FolderNamingBase < NamingBase
        exclude_from_registry

        def on_new_investigation
          super
          return unless (invalid_directory = invalid_directory_for_current_file)

          add_global_offense(format(folder_message, directory: invalid_directory, suffix: forbidden_suffix))
        end

        private

        def invalid_directory_for_current_file
          return unless path_inside_target_directory?

          current_path_parts = target_root_directory.split('/')
          path_parts_inside_target.each do |part|
            current_path_parts << part
            return current_path_parts.join('/') if part.end_with?(forbidden_suffix)
          end

          nil
        end

        def forbidden_suffix
          "_#{target_folder}"
        end

        def folder_message
          'Directory `%<directory>s` must not end with `%<suffix>s`.'
        end
      end
    end
  end
end
