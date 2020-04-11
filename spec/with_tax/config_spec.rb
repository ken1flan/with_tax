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

  describe '.rate_type' do
    subject { WithTax::Config.rate_type }

    context 'Without setting' do
      it { is_expected.to eq :default }
    end

    context 'With setting' do
      %i[floor round ceil].each do |rate_type|
        context "With #{rate_type}" do
          before { WithTax::Config.rate_type = rate_type }

          it { is_expected.to eq rate_type }
        end
      end
    end
  end
end
