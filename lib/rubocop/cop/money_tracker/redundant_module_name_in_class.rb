# frozen_string_literal: true

module RuboCop
  module Cop
    module MoneyTracker
      class RedundantModuleNameInClass < Base
        MSG = 'Class `%<class_name>s` should not include parent module name `%<module_name>s`.'

        def on_class(node)
          class_name = node.identifier.short_name.to_s
          module_name = duplicated_module_name(node, class_name)
          return unless module_name

          add_offense(
            node.identifier.loc.name,
            message: format(MSG, class_name: class_name, module_name: module_name)
          )
        end

        private

        def duplicated_module_name(node, class_name)
          downcased_class_name = class_name.downcase

          node.each_ancestor(:module)
              .map { |module_node| module_node.identifier.short_name.to_s }
              .find { |module_name| downcased_class_name.include?(module_name.downcase) }
        end
      end
    end
  end
end
