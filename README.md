# WithTax

WithTaxはクラスにincludeすると、`#attr_with_tax`(attrは任意の属性)によって税込みの金額を求められるようになります。

## Installation

Gemfileに下のように記述してください。

```ruby
gem 'with_tax'
```

それから下を実行してください:

```console
$ bundle install
```

または自分でインストールするには:

```console
$ gem install with_tax
```

## Usage

### 基本的な使い方

下のように`WithTax`を`extend`し、`attr_with_tax`で対象の属性を指定してください。

```ruby
class SampleItem
  extend WithTax

  attr_accessor :name, :price
  attr_with_tax :price

  def initialize(name, price)
    @name = name
    @price = price
  end
end
```

そうすると下のように`属性名_with_tax`というメソッドが利用できるようになり、税込み価格が取得できます。小数点以下は切り上げになっています。

```ruby
sample_item = SampleItem.new('Some item', 123)
sample_item.price # => 123
sample_item.price_with_tax #=> 136
```

### 適用日

税率改定があるときに、計算の基準になる日を指定することもできます。

```ruby
sample_item = SampleItem.new('Some item', 123)
sample_item.price # => 123
sample_item.price_with_tax(Date.parse('2019/09/30')) #=> 132
```

### カスタマイズ

#### 小数の取り扱い

デフォルトでは切り上げになっています。
ですが、`WithTax::Config.rounding_method`を設定することで切り替えることができます。

##### 切り捨て

`:floor`を設定すると小数点以下を切り捨てます。

```ruby
sample_item.price #=> 123
WithTax::Config.rounding_method = :floor
sample_item.price_with_tax #=> 135
```

```ruby
sample_item.price #=> 345
WithTax::Config.rounding_method = :floor
sample_item.price_with_tax #=> 379
```

##### 四捨五入

`:round`を設定すると小数点以下を四捨五入します。

```ruby
sample_item.price #=> 123
WithTax::Config.rounding_method = :round
sample_item.price_with_tax #=> 135
```

```ruby
sample_item.price #=> 345
WithTax::Config.rounding_method = :round
sample_item.price_with_tax #=> 380
```

##### 処理なし

`nil`を設定すると小数点以下を処理しません。

```ruby
sample_item.price #=> 123
WithTax::Config.rounding_method = nil
sample_item.price_with_tax #=> 135.3
```

#### 軽減税率

デフォルトでは`10%`ですが、`WithTax::Config.rate_type`に`:reduced`を設定することで軽減税率の8%に切り替えることができます。

```ruby
sample_item.price #=> 123
WithTax::Config.rate_type = :reduced
sample_item.price_with_tax #=> 133
```

##### 同一クラスで軽減税率対象かどうか変わる場合

同一クラスで軽減税率対象かどうか変わる場合、`#with_tax_rate_type`で適切な値を返すようにすると、`attr_with_tax`がそれを元に計算します。

```ruby
class Food
  include WithTax

  attr_accessor :name, :price, :sales_type

  def initialize(name, price, sales_type)
    @name = name
    @price = price
    @sales_type = sales_type
  end

  def with_tax_rate_type
    sales_type == :takeout ? :reduced : :default
  end
end

curry = Food.new('カレー', 500, :in_store)
curry.price #=> 500
curry.price_with_tax #=> 550

curry_takeout = Food.new('カレー(テイクアウト)', 500, :takeout)
curry_takeout.price #=> 500
curry_takeout.price_with_tax #=> 540
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ken1flan/with_tax.

