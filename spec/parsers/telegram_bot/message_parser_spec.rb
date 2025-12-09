# frozen_string_literal: true

require 'rails_helper'

describe TelegramBot::MessageParser do
  describe '#parse' do
    subject { described_class.new.parse(message) }

    let(:message) do
      <<-TEXT.strip
        #{message_method}
        #{action}
        #{body}
      TEXT
    end

    describe '#parse' do
      context 'when valid' do
        let(:message_method) { 'method: post;' }
        let(:action) { 'action: upsert;' }
        let(:body) do
          <<-TEXT
            body:
              spreadsheet_id: asdfasd;
              sheet_range: Октябрь!L30:N37;
              [01.01.2025; 12,01; Продукты];
          TEXT
        end

        it do
          expect { subject }.not_to raise_error
        end
      end
    end
  end
end
