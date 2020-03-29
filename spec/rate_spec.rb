RSpec.describe WithTax::Rate do
  describe ".rate" do
    subject { WithTax::Rate.rate }

    it { is_expected.to eq 0.10 }
  end
end
