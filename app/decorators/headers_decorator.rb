# frozen_string_literal: true

class HeadersDecorator < SimpleDelegator
  def action
    __getobj__[:message_action]
  end

  def method
    __getobj__[:message_method]
  end
end
