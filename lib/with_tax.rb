require "with_tax/version"

module WithTax
  class Error < StandardError; end

  def method_missing(name, *args)
    if name.match(/\A(.*)_with_tax\Z/)
      self.class.class_eval do
        define_method(name) do
          (send($1) * 1.10).ceil
        end
      end
      send(name)
    else
      super
    end
  end
end
