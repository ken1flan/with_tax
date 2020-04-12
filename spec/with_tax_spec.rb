RSpec.describe 'WithTax' do
  describe 'price_with_tax' do
    subject { sample_item.price_with_tax }

    let(:sample_item) { klass.new(price) }
    let(:klass) do
      Class.new do
        extend WithTax

        attr_accessor :price
        attr_with_tax :price

        def initialize(price)
          @price = price
        end
      end
    end

    before { Timecop.freeze(Date.parse(execution_date)) }
    after { Timecop.return }

    context 'price = 123のとき' do
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

    let(:sample_item) { klass.new(price) }
    let(:klass) do
      Class.new do
        extend WithTax

        attr_accessor :name, :price
        attr_with_tax :price

        def initialize(price)
          @price = price
        end
      end
    end

    context 'price = 123のとき' do
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

  describe '小数点以下の処理' do
    subject { sample_item.price_with_tax }

    let(:sample_item) { klass.new(price) }
    let(:klass) do
      Class.new do
        include WithTax

        attr_accessor :price

        def initialize(price)
          @price = price
        end
      end
    end

    before { Timecop.freeze(Date.parse('2019/10/01')) }
    after do
      Timecop.return
      WithTax::Config.rounding_method = :ceil
    end

    context '指定していないとき' do
      context 'price = 123のとき' do
        let(:price) { 123 }

        it '135.3 -> 136(切り上げ)であること' do
          expect(subject).to eql 136
        end
      end
    end

    context ':floorを指定したとき' do
      before { WithTax::Config.rounding_method = :floor }

      context 'price = 123のとき' do
        let(:price) { 123 }

        it '135.3 -> 135(切り捨て)であること' do
          expect(subject).to eql 135
        end
      end
    end

    context ':roundを指定したとき' do
      before { WithTax::Config.rounding_method = :round }

      context 'price = 123のとき' do
        let(:price) { 123 }

        it '135.3 -> 135(四捨五入)であること' do
          expect(subject).to eql 135
        end
      end

      context 'price = 345のとき' do
        let(:price) { 345 }

        it '379.5 -> 380(四捨五入)であること' do
          expect(subject).to eql 380
        end
      end
    end

    context ':ceilを指定したとき' do
      before { WithTax::Config.rounding_method = :ceil }

      context 'price = 123のとき' do
        let(:price) { 123 }

        it '135.3 -> 136(切り上げ)であること' do
          expect(subject).to eql 136
        end
      end
    end

    context 'nilを指定したとき' do
      before { WithTax::Config.rounding_method = nil }

      context 'price = 123のとき' do
        let(:price) { 123 }

        it '135.3(小数点以下がそのまま)であること' do
          expect(subject).to eql 135.3
        end
      end
    end
  end

  describe '税率種別の指定' do
    subject { sample_item.price_with_tax }

    let(:sample_item) { klass.new(price) }
    let(:klass) do
      Class.new do
        include WithTax

        attr_accessor :price

        def initialize(price)
          @price = price
        end
      end
    end

    before { Timecop.freeze(Date.parse('2019/10/01')) }
    after { Timecop.return }

    context '指定していないとき' do
      context 'price = 123のとき' do
        let(:price) { 123 }

        it '136(10%)であること' do
          expect(subject).to eql 136
        end
      end
    end

    context 'price = 123のとき' do
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

  describe 'より詳細な税率種別の指定' do
    subject { sample_item.price_with_tax }

    let(:sample_item) { klass.new(123) }
    let(:klass) do
      Class.new do
        include WithTax

        attr_accessor :price

        def initialize(price)
          @price = price
        end
      end
    end

    before { Timecop.freeze(Date.parse('2019/10/01')) }
    after { Timecop.return }

    context 'with_tax_rate_typeが定義されているとき' do
      before do
        allow(sample_item).to receive(:with_tax_rate_type).and_return(rate_type)
      end

      context 'with_tax_rate_typeが:defaultを返すとき' do
        let(:rate_type) { :default }

        it '136(10%)であること' do
          expect(subject).to eql 136
        end
      end

      context 'with_tax_rate_typeが:reducedを返すとき' do
        let(:rate_type) { :reduced }

        it '136(10%)であること' do
          expect(subject).to eql 133
        end
      end
    end
  end
end
