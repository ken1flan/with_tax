require 'bigdecimal'
require 'bigdecimal/util'
require 'with_tax/rate'
require 'with_tax/config'

module WithTax
  class MethodDefiner
    def self.add_method(target_class, name)
      target_class.class_eval do
        define_method(name) do |effective_date = nil|
          mag = 1 + WithTax::Rate.rate(effective_date, WithTax::Config.rate_type)
          ret = send(name.to_s.sub(/_with_tax\Z/, '')).to_s.to_d * mag

          rounding_method = WithTax::Config.rounding_method
          rounding_method ? ret.send(rounding_method) : ret
        end
      end
    end
  end
end
