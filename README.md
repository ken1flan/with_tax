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

下のように`WithTax`を`include`してください。

```ruby
class SampleItem
  include WithTax

  attr_accessor :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end
end
```

そうすると下のように`attr_with_tax`というメソッドが利用できるようになり、税込み価格が取得できます。小数点以下は切り上げになっています。

```ruby
sample_item = SampleItem.new('Some item', 123)
sample_item.price # => 123
sample_item.price_with_tax #=> 136
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

#### 軽減税率

デフォルトでは`10%｀ですが、`WithTax::Config.rate_type`に`:reduced`を設定することで軽減税率の8%に切り替えることができます。

```ruby
sample_item.price #=> 123
WithTax::Config.rate_type = :reduced
sample_item.price_with_tax #=> 133
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ken1flan/with_tax.

