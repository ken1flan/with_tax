RSpec.describe WithTax::MethodDefiner do
  describe '.add_method' do
    subject { sample_item }

    let(:sample_item) { klass.new(123) }
    let(:klass) do
      Class.new do
        attr_accessor :price

        def initialize(price)
          @price = price
        end
      end
    end

    before do
      WithTax::MethodDefiner.add_method(sample_item, :price_with_tax)
    end

    it { is_expected.to respond_to(:price_with_tax).with(1).argument }
  end
end
