require 'date'

module WithTax
  class Rate
    def self.rate(target_date = nil)
      t = target_date
      t ||= Date.today
      case t
      when Date.new...Date.new(1989, 4, 1)
        0.0
      when Date.new(1989, 4, 1)...Date.new(1997, 4, 1)
        0.03
      when Date.new(1997, 4, 1)...Date.new(2014, 4, 1)
        0.05
      when Date.new(2014, 4, 1)...Date.new(2019, 10, 1)
        0.08
      else
        0.10
      end
    end
  end
end
