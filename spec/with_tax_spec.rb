RSpec.describe 'WithTax' do
  describe 'SampleItem#price_with_tax' do
    subject { sample_item.price_with_tax }

    let(:sample_item) { SampleItem.new('SampleName', price) }

    before do
      class SampleItem
        include WithTax

        attr_accessor :name, :price

        def initialize(name, price)
          @name = name
          @price = price
        end
      end
      Timecop.freeze(Date.parse(execution_date))
    end

    after do
      Object.instance_eval { remove_const :SampleItem }
      Timecop.return
    end

    context 'SampleItem#price = 123のとき' do
      let(:price) { 123 }

      context '実行日が2019/10/01(2019/10/01消費税改定後)のとき' do
        let(:execution_date) { '2019/10/01' }

        it '135.3 -> 136(切り上げ)であること' do
          expect(subject).to eql 136
        end
      end

      context '実行日が2019/09/30(2019/10/01消費税改定前)のとき' do
        let(:execution_date) { '2019/09/30' }

        it '132.84 -> 133(切り上げ)であること' do
          expect(subject).to eql 133
        end
      end
    end
  end

  describe '適用日の指定' do
    subject { sample_item.price_with_tax(effective_date) }

    let(:sample_item) { SampleItem.new('SampleName', price) }

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

    context 'SampleItem#price = 123のとき' do
      let(:price) { 123 }

      context '適用日が2019/10/01(2019/10/01消費税改定後)のとき' do
        let(:effective_date) { Date.parse('2019/10/01') }

        it '136(10%)であること' do
          expect(subject).to eql 136
        end
      end

      context '適用日が2019/09/30(2019/10/01消費税改定前)のとき' do
        let(:effective_date) { Date.parse('2019/09/30') }

        it '133(8%)であること' do
          expect(subject).to eql 133
        end
      end
    end
  end

  describe 'WithTax::Config.rounding_method=' do
    subject { sample_item.price_with_tax }

    let(:sample_item) { SampleItem.new('SampleName', price) }

    before do
      class SampleItem
        include WithTax

        attr_accessor :name, :price

        def initialize(name, price)
          @name = name
          @price = price
        end
      end
      Timecop.freeze(Date.parse('2019/10/01'))
    end

    after do
      Object.instance_eval { remove_const :SampleItem }
      Timecop.return
      WithTax::Config.rounding_method = :ceil
    end

    context '指定していないとき' do
      context 'SampleItem#price = 123のとき' do
        let(:price) { 123 }

        it '135.3 -> 136(切り上げ)であること' do
          expect(subject).to eql 136
        end
      end
    end

    context ':floorを指定したとき' do
      before { WithTax::Config.rounding_method = :floor }

      context 'SampleItem#price = 123のとき' do
        let(:price) { 123 }

        it '135.3 -> 135(切り捨て)であること' do
          expect(subject).to eql 135
        end
      end
    end

    context ':roundを指定したとき' do
      before { WithTax::Config.rounding_method = :round }

      context 'SampleItem#price = 123のとき' do
        let(:price) { 123 }

        it '135.3 -> 135(四捨五入)であること' do
          expect(subject).to eql 135
        end
      end

      context 'SampleItem#price = 345のとき' do
        let(:price) { 345 }

        it '379.5 -> 380(四捨五入)であること' do
          expect(subject).to eql 380
        end
      end
    end

    context ':ceilを指定したとき' do
      before { WithTax::Config.rounding_method = :ceil }

      context 'SampleItem#price = 123のとき' do
        let(:price) { 123 }

        it '135.3 -> 136(切り上げ)であること' do
          expect(subject).to eql 136
        end
      end
    end

    context 'nilを指定したとき' do
      before { WithTax::Config.rounding_method = nil }

      context 'SampleItem#price = 123のとき' do
        let(:price) { 123 }

        it '135.3(小数点以下がそのまま)であること' do
          expect(subject).to eql 135.3
        end
      end
    end
  end

  describe 'WithTax::Config.rate_type=' do
    subject { sample_item.price_with_tax }

    let(:sample_item) { SampleItem.new('SampleName', price) }

    before do
      class SampleItem
        include WithTax

        attr_accessor :name, :price

        def initialize(name, price)
          @name = name
          @price = price
        end
      end
      Timecop.freeze(Date.parse('2019/10/01'))
    end

    after do
      Object.instance_eval { remove_const :SampleItem }
      Timecop.return
    end

    context '指定していないとき' do
      context 'SampleItem#price = 123のとき' do
        let(:price) { 123 }

        it '136(10%)であること' do
          expect(subject).to eql 136
        end
      end
    end

    context 'SampleItem#price = 123のとき' do
      let(:price) { 123 }

      context '指定していないとき' do
        it '136(10%)であること' do
          expect(subject).to eql 136
        end
      end

      context ':reducedを指定したとき' do
        before { WithTax::Config.rate_type = :reduced }

        it '133(8%)であること' do
          expect(subject).to eql 133
        end
      end
    end
  end
end
