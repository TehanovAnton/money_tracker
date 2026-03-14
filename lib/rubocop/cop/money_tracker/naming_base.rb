# frozen_string_literal: true

require 'yaml'

module RuboCop
  module Cop
    module MoneyTracker
      class NamingBase < Base
        exclude_from_registry

        private

        def target_folder
          return self.class::TARGET_FOLDER if self.class.const_defined?(:TARGET_FOLDER, false)

          current_app_folder
        end

        def target_root_directory
          @target_root_directory ||= "app/#{target_folder}"
        end

        def target_singular
          return self.class::TARGET_SINGULAR if self.class.const_defined?(:TARGET_SINGULAR, false)
          return configured_singular_name if configured_singular_name

          raise NotImplementedError, "#{self.class} must define TARGET_SINGULAR or override #target_singular"
        end

        def normalized_file_path
          @normalized_file_path ||= processed_source.file_path.to_s.delete_prefix('./').tr('\\', '/')
        end

        def current_app_folder
          @current_app_folder ||= normalized_file_path[%r{(?:\A|/)app/([^/]+)/}, 1]
        end

        def configured_folder?
          return false unless current_app_folder

          naming_folders.key?(current_app_folder)
        end

        def configured_singular_name
          return unless configured_folder?

          folder_config = naming_folders[current_app_folder]
          return unless folder_config.is_a?(Hash)

          singular_name = folder_config['singular_name']
          singular_name if singular_name.is_a?(String) && !singular_name.empty?
        end

        def naming_folders
          folders = naming_config['folders']
          return {} unless folders.is_a?(Hash)

          folders
        end

        def path_inside_target_directory?
          normalized_file_path.match?(%r{(?:\A|/)#{Regexp.escape(target_root_directory)}/})
        end

        def path_parts_inside_target
          path_in_root = normalized_file_path.split(%r{#{Regexp.escape(target_root_directory)}/}, 2).last
          return [] unless path_in_root

          path_in_root.split('/')[0...-1]
        end

        def naming_config
          @naming_config ||= begin
            config_path = File.expand_path('naming_config.yml', __dir__)
            raw_config = YAML.safe_load(File.read(config_path), aliases: false) || {}
            raw_config.is_a?(Hash) ? raw_config : {}
          end
        rescue Errno::ENOENT, Psych::SyntaxError
          {}
        end
      end
    end
  end
end
