# frozen_string_literal: true

module ExtensibleService
  def do_extend
    @extensiable_service_result = nil

    # pre_work + around_work
    extensoin_registry \
      .select { |extension_info| %i[around_work pre_work].include?(extension_info[:place_holder]) }
      .each do |extension_info|
        extension_info[:call_method].call(
          called_from_place_holder: :pre_work,
          place_holder: extension_info[:place_holder]
        )
      end

    @extensiable_service_result = yield

    # after_work + around_work
    extensoin_registry \
      .select { |extension_info| %i[around_work after_work].include?(extension_info[:place_holder]) }
      .each do |extension_info|
        extension_info[:call_method].call(
          called_from_place_holder: :after_work,
          place_holder: extension_info[:place_holder]
        )
      end

    @extensiable_service_result
  end

  def extensoin_registry
    @extensoin_registry ||= []
  end

  def register_extnsion(**extension_args)
    extensoin_registry << extension_args
  end
end
