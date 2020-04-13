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

### 詳細設定

#### 小数の取り扱い

デフォルトでは切り上げになっていますが、`rounding_method`を設定することで切り替えることができます。

```ruby
class SampleItem
  extend WithTax

  attr_accessor :name, :price
  attr_with_tax :price, rounding_method: :floor

  def initialize(name, price)
    @name = name
    @price = price
  end
end
```

##### 切り捨て

`:floor`を設定すると小数点以下を切り捨てます。

```ruby
class SampleItem
  extend WithTax

  attr_accessor :name, :price
  attr_with_tax :price, rounding_method: :floor

  def initialize(name, price)
    @name = name
    @price = price
  end
end

sample_item1 = SampleItem.new('Sample Item', 123)
sample_item1.price #=> 123
sample_item1.price_with_tax #=> 135

sample_item2 = SampleItem.new('Sample Item', 345)
sample_item2.price #=> 345
sample_item2.price_with_tax #=> 379
```

##### 四捨五入

`:round`を設定すると小数点以下を四捨五入します。

```ruby
class SampleItem
  extend WithTax

  attr_accessor :name, :price
  attr_with_tax :price, rounding_method: :round

  def initialize(name, price)
    @name = name
    @price = price
  end
end

sample_item1 = SampleItem.new('Sample Item', 345)
sample_item1.price #=> 123
sample_item1.price_with_tax #=> 135

sample_item2 = SampleItem.new('Sample Item', 345)
sample_item2.price #=> 345
sample_item2.price_with_tax #=> 380
```

##### 処理なし

`nil`を設定すると小数点以下を処理しません。

```ruby
class SampleItem
  extend WithTax

  attr_accessor :name, :price
  attr_with_tax :price, rounding_method: nil

  def initialize(name, price)
    @name = name
    @price = price
  end
end

sample_item.price #=> 123
sample_item.price_with_tax #=> 135.3
```

#### 軽減税率

デフォルトでは`10%`ですが、`rate_type`に`:reduced`を設定することで軽減税率の8%に切り替えることができます。

```ruby
class SampleItem
  extend WithTax

  attr_accessor :name, :price
  attr_with_tax :price, rate_type: :reduced

  def initialize(name, price)
    @name = name
    @price = price
  end
end
```

```ruby
sample_item.price #=> 123
sample_item.price_with_tax #=> 133
```

#### 複数のオプション設定

`attr_with_max`は複数のオプションも設定できます。

```ruby
class SampleItem
  extend WithTax

  attr_accessor :name, :price
  attr_with_tax :price, rounding_method: :round, rate_type: :reduced

  def initialize(name, price)
    @name = name
    @price = price
  end
end
```

```ruby
sample_item.price #=> 123
sample_item.price_with_tax #=> 133
```

#### 複数の属性への設定

`attr_with_max`は複数の属性にも設定できます。

```ruby
class SampleItem
  extend WithTax

  attr_accessor :name, :price, :price_takeout
  attr_with_tax :price, rounding_method: :round
  attr_with_tax :price_takeout, rounding_method: :round, rate_type: :reduced

  def initialize(name, price, price_takeout)
    @name = name
    @price = price
    @price_takeout = price_takeout
  end
end
```

```ruby
sample_item.price #=> 123
sample_item.price_with_tax #=> 135
sample_item.price_takeout #=> 123
sample_item.price_takeout_with_tax #=> 133
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ken1flan/with_tax.

