require "with_tax/version"

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
        (send(name.to_s.delete_suffix("_with_tax")) * 1.10).ceil
      end
    end
  end
end
