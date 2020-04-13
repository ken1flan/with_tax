RSpec.describe 'WithTax' do
  describe 'バージョン' do
    it "バージョン番号があること" do
      expect(WithTax::VERSION).not_to be nil
    end
  end

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
      example = self
      Class.new do
        extend WithTax

        attr_accessor :price
        attr_with_tax :price, rounding_method: example.rounding_method

        def initialize(price)
          @price = price
        end
      end
    end

    before { Timecop.freeze(Date.parse('2019/10/01')) }
    after { Timecop.return }

    context ':floorを指定したとき' do
      let(:rounding_method) { :floor }

      context 'price = 123のとき' do
        let(:price) { 123 }

        it '135.3 -> 135(切り捨て)であること' do
          expect(subject).to eql 135
        end
      end
    end

    context ':roundを指定したとき' do
      let(:rounding_method) { :round }

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
      let(:rounding_method) { :ceil }

      context 'price = 123のとき' do
        let(:price) { 123 }

        it '135.3 -> 136(切り上げ)であること' do
          expect(subject).to eql 136
        end
      end
    end

    context 'nilを指定したとき' do
      let(:rounding_method) { nil }

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
      expect = self
      Class.new do
        extend WithTax

        attr_accessor :price
        attr_with_tax :price, rate_type: expect.rate_type

        def initialize(price)
          @price = price
        end
      end
    end

    before { Timecop.freeze(Date.parse('2019/10/01')) }
    after { Timecop.return }

    context 'price = 123のとき' do
      let(:price) { 123 }

      context ':defaultを指定したとき' do
        let(:rate_type) { :default }

        it '136(10%)であること' do
          expect(subject).to eql 136
        end
      end

      context ':reducedを指定したとき' do
        let(:rate_type) { :reduced }

        it '133(8%)であること' do
          expect(subject).to eql 133
        end
      end
    end
  end

  describe '複数のオプション指定' do
    subject { sample_item.price_with_tax }

    let(:sample_item) { klass.new(price) }
    let(:klass) do
      expect = self
      Class.new do
        extend WithTax

        attr_accessor :price
        attr_with_tax :price, rounding_method: expect.rounding_method, rate_type: expect.rate_type

        def initialize(price)
          @price = price
        end
      end
    end

    before { Timecop.freeze(Date.parse('2019/10/01')) }
    after { Timecop.return }

    context '小数点以下の処理に:round、税率種別に:reducedを指定したとき' do
      let(:rounding_method) { :round }
      let(:rate_type) { :reduced }

      context 'price = 123のとき' do
        let(:price) { 123 }

        it '123 * 1.08 -> 132.8 -> 133(四捨五入かつ8%)であること' do
          expect(subject).to eql 133
        end
      end
    end
  end
  describe '複数の属性への指定' do
    let(:sample_item) { klass.new(price, price) }
    let(:klass) do
      expect = self
      Class.new do
        extend WithTax

        attr_accessor :price, :price_takeout
        attr_with_tax :price, rounding_method: expect.rounding_method
        attr_with_tax :price_takeout, rounding_method: expect.rounding_method, rate_type: expect.rate_type

        def initialize(price, price_takeout)
          @price = price
          @price_takeout = price_takeout
        end
      end
    end

    context 'priceの小数点以下の処理に:round、price_takeoutの小数点以下の処理に:round、税率種別に:reducedを指定したとき' do
      let(:rounding_method) { :round }
      let(:rate_type) { :reduced }

      context 'price = 123、price_takeout = 123のとき' do
        let(:price) { 123 }

        it 'price_with_taxは123 * 1.10 -> 135.3 -> 135(四捨五入かつ10%)であること' do
          expect(sample_item.price_with_tax).to eql 135
        end

        it 'price_takeout_with_taxは123 * 1.08 -> 132.8 -> 133(四捨五入かつ8%)であること' do
          expect(sample_item.price_takeout_with_tax).to eql 133
        end
      end
    end
  end
end
