# frozen_string_literal: true

class User < ApplicationRecord
  has_one :layout_cursor_action,
          class_name: 'LayoutAction',
          dependent: :destroy
end
