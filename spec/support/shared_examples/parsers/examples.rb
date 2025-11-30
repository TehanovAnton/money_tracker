# frozen_string_literal: true

shared_examples 'parsed exactly' do |elements|
  elements.each do |element|
    context "Try: `#{element}`" do
      let(:expression) { element }

      it do
        # binding.pry
        expect(subject[expression_key]).to eq(expected_element)
      end
    end
  end
end

shared_examples 'parsed succesfully' do |elements|
  elements.each do |element|
    context "Try: `#{element}`" do
      let(:expression) { element }

      it do
        expect { subject }.not_to raise_error
      end
    end
  end
end

shared_examples 'parsing error' do |elements|
  elements.each do |element|
    context "Try: `#{element}`" do
      let(:expression) { element }

      it do
        expect { subject }.to raise_error
      end
    end
  end
end
