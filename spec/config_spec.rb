RSpec.describe WithTax::Config do
  describe '.rounding_method' do
    subject { WithTax::Config.rounding_method }

    context 'Without setting' do
      it { is_expected.to eq :ceil }
    end

    context 'With setting' do
      %i[floor round ceil].each do |method_name|
        context "With #{method_name}" do
          before { WithTax::Config.rounding_method = method_name }

          it { is_expected.to eq method_name }
        end
      end
    end
  end
end
