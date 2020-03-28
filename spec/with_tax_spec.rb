RSpec.describe WithTax do
  describe "WithTax::VERSION" do
    it "has a version number" do
      expect(WithTax::VERSION).not_to be nil
    end
  end

  describe "#???_with_tax" do
    context "SampleItem class exist" do
      class SampleItem
        include WithTax

        attr_accessor :name, :price

        def initialize(name, price)
          @name = name
          @price = price
        end
      end

      describe "SampleItem#price_with_tax" do
        subject { sample_item.price_with_tax }

        let(:sample_item) { SampleItem.new("SampleName", price) }
        let(:price) { rand(10000) + 1 }

        it { is_expected.to eq (price * 1.10).ceil }
      end
    end
  end
end
