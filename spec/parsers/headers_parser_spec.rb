# frozen_string_literal: true

require 'rails_helper'

describe HeadersParser do
  describe '#parse' do
    subject(:parser) { described_class.new.parse(message) }

    let(:message) do
      <<-TEXT.strip
        #{message_method}
        #{action}
      TEXT
    end

    describe '#parse' do
      context 'when valid' do
        let(:message_method) { 'method: post;' }
        let(:action) { 'action: upsert;' }

        it do
          expect { parser }.not_to raise_error
        end
      end
    end
  end
end
