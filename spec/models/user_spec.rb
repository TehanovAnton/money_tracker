# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:add_expense_saved_input) { FactoryBot.create(:add_expense_saved_input) }
  let!(:command_setting) do
    FactoryBot.create(:add_expense_command_setting, user: user, savable_input: add_expense_saved_input)
  end

  it do
    expect(user.add_expense_saved_input).to eq(add_expense_saved_input)
  end
end
