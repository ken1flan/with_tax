require 'bigdecimal'
require 'bigdecimal/util'
require 'with_tax/rate'
require 'with_tax/config'

module WithTax
  class MethodDefiner
    def self.add_method(klass, attr_name, rounding_method: :ceil, rate_type: :default)
      klass.class_eval do
        method_name = "#{attr_name}_with_tax"
        define_method(method_name) do |effective_date = nil|
          mag = 1 + WithTax::Rate.rate(effective_date, rate_type)
          ret = send(attr_name).to_s.to_d * mag

          rounding_method ? ret.send(rounding_method) : ret
        end
      end
    end
  end
end
