module WithTax
  class Config
    @_with_tax_rounding_method = :ceil

    def self.rounding_method=(method_name)
      @_with_tax_rounding_method = method_name
    end

    def self.rounding_method
      @_with_tax_rounding_method
    end

    def self.rate_type=(rate_type)
      @_with_tax_rate_type = rate_type
    end

    def self.rate_type
      @_with_tax_rate_type
    end
  end
end
