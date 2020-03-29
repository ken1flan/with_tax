require 'bigdecimal'
require 'bigdecimal/util'
require "with_tax/version"

module WithTax
  class Error < StandardError; end

  @_with_tax_rounding_method = :ceil

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
        ret = send(name.to_s.delete_suffix("_with_tax")).to_s.to_d * 1.10

        rounding_method = WithTax.rounding_method
        rounding_method ? ret.send(rounding_method) : ret
      end
    end
  end

  def self.rounding_method=(strategy)
    @_with_tax_rounding_method = strategy
  end

  def self.rounding_method
    @_with_tax_rounding_method
  end
end
