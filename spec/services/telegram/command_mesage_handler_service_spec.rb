# frozen_string_literal: true

require 'rails_helper'

describe Telegram::CommandMesageHandlerService do
  subject(:result) { described_class.run!(user: user, message_text: text) }

  let(:user) { FactoryBot.create(:user) }

  describe '/spreadsheets --add command' do
    describe 'success cases' do
      let(:text) { '/spreadsheets --add --document_id="new-doc" --expense_range="Sheet1!A1:B1"' }
      let(:new_spreadsheet) { user.spreadsheets.last }

      it do
        expect(result.class).to be(String)
        expect(new_spreadsheet).to be_valid
      end
    end
  end
end
