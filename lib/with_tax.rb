require 'bigdecimal'
require 'bigdecimal/util'
require 'with_tax/version'
require 'with_tax/rate'
require 'with_tax/config'

module WithTax
  class Error < StandardError; end

  def method_missing(name, *args)
    if name.match(/\A(.*)_with_tax\Z/)
      add_with_tax_method(name)
      send(name)
    else
      super
    end
  end

  def add_with_tax_method(name)
    self.class.class_eval do
      define_method(name) do
        ret = send(name.to_s.delete_suffix("_with_tax")).to_s.to_d * (1 + WithTax::Rate.rate(nil, WithTax::Config.rate_type))

        rounding_method = WithTax::Config.rounding_method
        rounding_method ? ret.send(rounding_method) : ret
      end
    end
  end
end
