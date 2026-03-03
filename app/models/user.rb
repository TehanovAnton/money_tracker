# frozen_string_literal: true

class User < ApplicationRecord
  has_one :chat_context,
          -> { order(updated_at: :desc) },
          dependent: :destroy,
          inverse_of: :user
  has_one :layout_cursor_action,
          class_name: 'LayoutAction',
          dependent: :destroy
end
