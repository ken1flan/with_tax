RSpec.describe WithTax::Rate do
  describe ".rate" do
    subject { WithTax::Rate.rate(target_date) }

    context "When target_date = nil" do
      let(:target_date) { nil }
      before { Timecop.freeze(Date.parse(today)) }
      after { Timecop.return }

      context "When today is 1989/03/31" do
        let(:today) { "1989/03/31" }

        it { is_expected.to eq 0.0 }
      end

      context "When today is 1989/04/01" do
        let(:today) { "1989/04/01" }

        it { is_expected.to eq 0.03 }
      end

      context "When today is 1997/03/31" do
        let(:today) { "1997/03/31" }

        it { is_expected.to eq 0.03 }
      end

      context "When today is 1997/04/01" do
        let(:today) { "1997/04/01" }

        it { is_expected.to eq 0.05 }
      end

      context "When today is 2014/03/31" do
        let(:today) { "2014/03/31" }

        it { is_expected.to eq 0.05 }
      end

      context "When today is 2014/04/01" do
        let(:today) { "2014/04/01" }

        it { is_expected.to eq 0.08 }
      end

      context "When today is 2019/09/30" do
        let(:today) { "2019/09/30" }

        it { is_expected.to eq 0.08 }
      end

      context "When today is 2019/10/01" do
        let(:today) { "2019/10/01" }

        it { is_expected.to eq 0.10 }
      end
    end

    context "When target_date = 1989/03/31" do
      let(:target_date) { Date.new(1989, 3, 31) }

      it { is_expected.to eq 0.0 }
    end

    context "When target_date = 1989/04/01" do
      let(:target_date) { Date.new(1989, 4, 1) }

      it { is_expected.to eq 0.03 }
    end

    context "When target_date = 1997/03/31" do
      let(:target_date) { Date.new(1997, 3, 31) }

      it { is_expected.to eq 0.03 }
    end

    context "When target_date = 1997/04/01" do
      let(:target_date) { Date.new(1997, 4, 1) }

      it { is_expected.to eq 0.05 }
    end

    context "When target_date = 2014/03/31" do
      let(:target_date) { Date.new(2014, 3, 31) }

      it { is_expected.to eq 0.05 }
    end

    context "When target_date = 2014/04/01" do
      let(:target_date) { Date.new(2014, 4, 1) }

      it { is_expected.to eq 0.08 }
    end

    context "When target_date = 2019/09/30" do
      let(:target_date) { Date.new(2019, 9, 30) }

      it { is_expected.to eq 0.08 }
    end

    context "When target_date = 2019/10/01" do
      let(:target_date) { Date.new(2019, 10, 1) }

      it { is_expected.to eq 0.10 }
    end
  end
end
