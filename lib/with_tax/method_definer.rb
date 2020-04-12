require 'bigdecimal'
require 'bigdecimal/util'
require 'with_tax/rate'
require 'with_tax/config'

module WithTax
  class MethodDefiner
    def self.add_method(klass, attr_name)
      klass.class_eval do
        method_name = "#{attr_name}_with_tax"
        define_method(method_name) do |effective_date = nil|
          rate_type = respond_to?(:with_tax_rate_type) ? with_tax_rate_type : WithTax::Config.rate_type
          mag = 1 + WithTax::Rate.rate(effective_date, rate_type)
          ret = send(attr_name).to_s.to_d * mag

          rounding_method = WithTax::Config.rounding_method
          rounding_method ? ret.send(rounding_method) : ret
        end
      end
    end
  end
end
