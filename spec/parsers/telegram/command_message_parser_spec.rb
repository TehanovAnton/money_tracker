# frozen_string_literal: true

require 'rails_helper'

describe Telegram::CommandMessageParser do
  subject(:parsed_input) do
    described_class
      .new
      .parse(text)
      .transform_keys(&:to_sym)
      .transform_values(&:to_s)
  end

  describe 'command namespace parsing' do
    describe 'success cases' do
      shared_examples 'parsed namespace' do |args|
        let(:text) { args[:text] }

        it do
          expect(subject[:namespace]).to eq(args[:expected_namespace])
        end
      end

      shared_examples 'parsed namespaces' do |args|
        args[:namespaces].each do |namespace|
          it_behaves_like 'parsed namespace', text: namespace[:text], expected_namespace: namespace[:expected_namespace]
        end
      end

      include_examples 'parsed namespaces', namespaces: [
        { text: '/spreadsheet', expected_namespace: 'spreadsheet' },
        { text: '/spreadsheet_1_2', expected_namespace: 'spreadsheet_1_2' },
        { text: '/1spreadsheet3', expected_namespace: '1spreadsheet3' },
        { text: '  /spreadsheet', expected_namespace: 'spreadsheet' },
        { text: '    /spreadsheet', expected_namespace: 'spreadsheet' },
        { text: "\n/spreadsheet", expected_namespace: 'spreadsheet' },
        { text: "\n   /spreadsheet", expected_namespace: 'spreadsheet' }
      ]
    end

    describe 'fail cases' do
      shared_examples 'fail to parse namespace' do |args|
        let(:text) { args[:text] }

        it do
          expect { subject }.to raise_error(Parslet::ParseFailed)
        end
      end

      shared_examples 'fail to parse namespaces' do |args|
        args[:namespaces].each do |namespace|
          it_behaves_like 'fail to parse namespace', text: namespace
        end
      end

      it_behaves_like 'fail to parse namespaces', namespaces: [
        '/ spreadsheet',
        '/spr eadsheet',
        '-spreadsheet',
        '/Spreadsheet',
        '//spreadsheet'
      ]
    end
  end

  describe 'command name parsing' do
    describe 'success cases' do
      shared_examples 'parsed command name' do |args|
        let(:text) { args[:text] }

        it do
          expect(subject[:command]).to eq(args[:expected_command])
        end
      end

      shared_examples 'parsed command names' do |args|
        args[:commands].each do |command|
          it_behaves_like 'parsed command name', text: command[:text], expected_command: command[:expected_command]
        end
      end

      include_examples 'parsed command names', commands: [
        { text: '/namespace --list_all', expected_command: 'list_all' },
        { text: '/namespace --list', expected_command: 'list' },
        { text: '/namespace --list_all_you_want', expected_command: 'list_all_you_want' },
        { text: '/namespace -list', expected_command: 'list' },
        { text: '/namespace —list', expected_command: 'list' }
      ]
    end

    describe 'fail cases' do
      shared_examples 'fail to parse command name' do |args|
        let(:text) { args[:text] }

        it do
          expect { subject }.to raise_error(Parslet::ParseFailed)
        end
      end

      shared_examples 'fail to parse command names' do |args|
        args[:commands].each do |command|
          it_behaves_like 'fail to parse command name', text: command
        end
      end

      include_examples 'fail to parse command names', commands: [
        '/namespace ---list_all',
        '/namespace ——list_all',
        '/namespace-list_all',
        '/namespace -List_all',
        '/namespace -'
      ]
    end
  end

  describe 'flag parameter parsing' do
    subject(:parameters) { described_class.new.parse(text)[:parameters].map { |p| p.transform_values(&:to_s) } }

    describe 'success cases' do
      shared_examples 'parsed flag' do |args|
        let(:text) { args[:text] }

        it do
          expect(parameters).to include(*args[:expected_flags])
        end
      end

      shared_examples 'parsed flags' do |args|
        args[:flags].each do |flag|
          it_behaves_like 'parsed flag', text: flag[:text], expected_flags: flag[:expected_flags]
        end
      end

      include_examples 'parsed flags', flags: [
        { text: '/namespace --show --some_flag', expected_flags: [{ name: 'some_flag' }] },
        {
          text: '/namespace --show --some_flag --other_flag',
          expected_flags: [{ name: 'some_flag' }, { name: 'other_flag' }]
        }
      ]
    end

    describe 'fail cases' do
      shared_examples 'fail to parse flag' do |args|
        let(:text) { args[:text] }

        it do
          expect { parameters }.to raise_error(Parslet::ParseFailed)
        end
      end

      shared_examples 'fail to parse flags' do |args|
        args[:flags].each do |flag|
          it_behaves_like 'fail to parse flag', text: flag
        end
      end

      include_examples 'fail to parse flags', flags: [
        '/namespace --show --Some_flag',
        '/namespace --show ---some_flag',
        '/namespace --show--some_flag',
        '/namespace --show--some_flag ',
        '/namespace --show some_flag',
        '/namespace --show --some_flag--other_flag',
        '/namespace --show --some_flag other_flag'
      ]
    end
  end

  describe 'named parameter parsing' do
    subject(:parameters) { described_class.new.parse(text)[:parameters].map { |p| p.transform_values(&:to_s) } }

    describe 'success cases' do
      shared_examples 'parsed named parameter' do |args|
        let(:text) { args[:text] }

        it do
          # binding.pry
          expect(parameters).to include(*args[:expected_parameters])
        end
      end

      shared_examples 'parsed named parameters' do |args|
        args[:parameters].each do |parameter|
          it_behaves_like 'parsed named parameter',
                          text: parameter[:text],
                          expected_parameters: parameter[:expected_parameters]
        end
      end

      include_examples 'parsed named parameters', parameters: [
        {
          text: '/namespace --show --some_flag="TheValue"',
          expected_parameters: [{ name: 'some_flag', value: 'TheValue' }]
        },
        {
          text: '/namespace --show  --some_flag="TheValue"',
          expected_parameters: [{ name: 'some_flag', value: 'TheValue' }]
        },
        {
          text: "/namespace --show  \n    --some_flag=\"TheValue\"",
          expected_parameters: [{ name: 'some_flag', value: 'TheValue' }]
        },
        {
          text: '/namespace --show --some_flag="The Value"',
          expected_parameters: [{ name: 'some_flag', value: 'The Value' }]
        },
        {
          text: '/namespace --show --some_flag=\'the "value"\'',
          expected_parameters: [{ name: 'some_flag', value: 'the "value"' }]
        },
        {
          text: '/namespace --show --some_flag="the \'value\'"',
          expected_parameters: [{ name: 'some_flag', value: "the 'value'" }]
        },
        {
          text: '/namespace --show --some_flag="the 1234"',
          expected_parameters: [{ name: 'some_flag', value: 'the 1234' }]
        },
        {
          text: '/namespace --show --some_flag="1234"',
          expected_parameters: [{ name: 'some_flag', value: '1234' }]
        },
        {
          text: '/namespace --show --some_flag=""',
          expected_parameters: [{ name: 'some_flag', value: '' }]
        },
        {
          text: "/namespace --show --some_flag=''",
          expected_parameters: [{ name: 'some_flag', value: '' }]
        }
      ]
    end

    describe 'fail cases' do
      shared_examples 'fail to parse named parameter' do |args|
        let(:text) { args[:text] }

        it do
          expect { parameters }.to raise_error(Parslet::ParseFailed)
        end
      end

      shared_examples 'fail to parse named parameters' do |args|
        args[:parameters].each do |parameter|
          it_behaves_like 'fail to parse named parameter', text: parameter
        end
      end

      include_examples 'fail to parse named parameters', parameters: [
        '/namespace --show --some_flag=TheValue',
        '/namespace --show --some_flag="TheValue',
        '/namespace --show --some_flag=TheValue"',
        '/namespace --show--some_flag="TheValue"',
        '/namespace --show ---some_flag="TheValue" '
      ]
    end
  end

  describe 'composed variants' do
    describe 'success cases' do
      shared_examples 'well parsed command' do |args|
        let(:text) { args[:text] }

        it do
          expect { subject }.not_to raise_error
        end
      end

      shared_examples 'well parsed commands' do |args|
        args[:commands].each do |command|
          it_behaves_like 'well parsed command', text: command
        end
      end

      include_examples 'well parsed commands', commands: [
        '/namespace --some_param="TheValue"',
        '/namespace --some_command --some_param_1 --some_param_2="TheValue" --some_param_3 --some_param_4="TheValue"',
        "\n    /namespace --some_command --some_param_1 --some_param_2=\"TheValue\"   "
      ]
    end

    describe 'fail cases' do
      shared_examples 'fail to parse' do |args|
        let(:text) { args[:text] }

        it do
          expect { subject }.to raise_error(Parslet::ParseFailed)
        end
      end

      it_behaves_like 'fail to parse', text: '/ --some_param'
    end
  end
end
