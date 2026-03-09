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

        def target_singular
          return self.class::TARGET_SINGULAR if self.class.const_defined?(:TARGET_SINGULAR, false)

          raise NotImplementedError, "#{self.class} must define TARGET_SINGULAR or override #target_singular"
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
    end
  end
end
