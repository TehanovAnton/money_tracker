# frozen_string_literal: true

module RuboCop
  module Cop
    module MoneyTracker
      class DecoratorsFolderNaming < Base
        MSG = 'Directory `%<directory>s` must not end with `_decorators`.'
        ROOT_DIRECTORY = 'app/decorators'
        FORBIDDEN_SUFFIX = '_decorators'

        def on_new_investigation
          super
          return unless (invalid_directory = invalid_directory_for_current_file)

          add_global_offense(format(MSG, directory: invalid_directory))
        end

        private

        def invalid_directory_for_current_file
          return unless path_inside_root_directory?

          current_path_parts = ROOT_DIRECTORY.split('/')
          path_parts_inside_root.each do |part|
            current_path_parts << part
            return current_path_parts.join('/') if part.end_with?(FORBIDDEN_SUFFIX)
          end

          nil
        end

        def path_inside_root_directory?
          normalized_file_path.match?(%r{(?:\A|/)#{Regexp.escape(ROOT_DIRECTORY)}/})
        end

        def path_parts_inside_root
          path_in_root = normalized_file_path.split(%r{#{Regexp.escape(ROOT_DIRECTORY)}/}, 2).last
          return [] unless path_in_root

          path_in_root.split('/')[0...-1]
        end

        def normalized_file_path
          @normalized_file_path ||= processed_source.file_path.to_s.delete_prefix('./').tr('\\', '/')
        end
      end
    end
  end
end
