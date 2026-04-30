# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Telegram::Commands::Spreadsheets::DeleteService, type: :service do
  let(:user) { create(:user) }
  let(:document_id) { 'test_document_123' }

  describe '#run!' do
    subject { described_class.run!(user: user, document_id: document_id) }

    context 'when spreadsheet exists for user' do
      let!(:spreadsheet) { create(:spreadsheet, user: user, document_id: document_id) }

      it 'deletes the spreadsheet' do
        expect { subject }.to change { Spreadsheet.where(user_id: user.id).count }.by(-1)
        expect(Spreadsheet.exists?(spreadsheet.id)).to be false
      end

      it 'returns success message' do
        expect(subject).to eq("Таблица #{document_id} успешно удалена")
      end
    end

    context 'when spreadsheet does not exist' do
      it 'does not delete any spreadsheet' do
        expect { subject }.not_to(change(Spreadsheet, :count))
      end

      it 'returns not found message' do
        expect(subject).to eq('Таблица не найдена')
      end
    end

    context 'when spreadsheet belongs to another user' do
      let(:other_user) { create(:user) }
      let!(:spreadsheet) { create(:spreadsheet, user: other_user, document_id: document_id) }

      it 'does not delete other user spreadsheet' do
        expect { subject }.not_to(change(Spreadsheet, :count))
      end

      it 'returns not found message' do
        expect(subject).to eq('Таблица не найдена')
      end
    end
  end
end
