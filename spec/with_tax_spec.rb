RSpec.describe WithTax do
  before do
    class SampleItem
      include WithTax

      attr_accessor :name, :price

      def initialize(name, price)
        @name = name
        @price = price
      end
    end
  end

  after do
    Object.instance_eval { remove_const :SampleItem }
  end

  describe "WithTax::VERSION" do
    it "has a version number" do
      expect(WithTax::VERSION).not_to be nil
    end
  end

  describe "SampleItem#price_with_tax" do
    subject { sample_item.price_with_tax }

    let(:sample_item) { SampleItem.new("SampleName", price) }
    let(:price) { rand(10000) + 1 }

    it { is_expected.to eq (price * 1.10).ceil }
  end

  describe "#rounding_method" do
    subject { sample_item.price_with_tax }

    let(:sample_item) { SampleItem.new("SampleName", price) }

    context "When rounding_method = nil" do
      before { WithTax.rounding_method = nil }

      context "When price = 123" do
        let(:price) { 123 }

        it { is_expected.to eq 135.3 }
      end

      context "When price = 345" do
        let(:price) { 345 }

        it { is_expected.to eq 379.5 }
      end
    end

    context "When rounding_method = :floor" do
      before { WithTax.rounding_method = :floor }

      context "When price = 123" do
        let(:price) { 123 }

        it { is_expected.to eq 135 }
      end

      context "When price = 345" do
        let(:price) { 345 }

        it { is_expected.to eq 379 }
      end
    end

    context "When rounding_method = :round" do
      before { WithTax.rounding_method = :round }

      context "When price = 123" do
        let(:price) { 123 }

        it { is_expected.to eq 135 }
      end

      context "When price = 345" do
        let(:price) { 345 }

        it { is_expected.to eq 380 }
      end
    end

    context "When rounding_method = :ceil" do
      before { WithTax.rounding_method = :ceil }

      context "When price = 123" do
        let(:price) { 123 }

        it { is_expected.to eq 136 }
      end

      context "When price = 345" do
        let(:price) { 345 }

        it { is_expected.to eq 380 }
      end
    end
  end
end
