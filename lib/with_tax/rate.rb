require 'date'
require 'yaml'

module WithTax
  class Rate
    TAX_TABLE = File.open("#{__dir__}/rate.yml") { |f| YAML.safe_load(f) }

    def self.rate(target_date = nil, target_type = nil)
      t = target_date
      t ||= Date.today
      _k, rate = TAX_TABLE.find { |k, _v| Date.parse(k) <= t }
      rate ||= {}
      rate[target_type&.to_s] || rate['default'] || 0.0
    end
  end
end
