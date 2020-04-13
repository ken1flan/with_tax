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

    context 'With only attr_name' do
      before do
        WithTax::MethodDefiner.add_method(sample_item.class, :price)
      end

      it { is_expected.to respond_to(:price_with_tax).with(1).argument }
    end

    context 'With attr_name and rounding_method' do
      before do
        WithTax::MethodDefiner.add_method(sample_item.class, :price, rounding_method: :floor)
      end

      it { is_expected.to respond_to(:price_with_tax).with(1).argument }
    end

    context 'With attr_name and rate_type' do
      before do
        WithTax::MethodDefiner.add_method(sample_item.class, :price, rate_type: :reduced)
      end

      it { is_expected.to respond_to(:price_with_tax).with(1).argument }
    end

    context 'With attr_name, rounding_method and rate_type' do
      before do
        WithTax::MethodDefiner.add_method(sample_item.class, :price, rounding_method: :floor, rate_type: :reduced)
      end

      it { is_expected.to respond_to(:price_with_tax).with(1).argument }
    end
  end
end
