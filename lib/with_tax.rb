require 'with_tax/version'
require 'with_tax/method_definer'

module WithTax
  class Error < StandardError; end

  def attr_with_tax(option)
    attr_name = option
    WithTax::MethodDefiner.add_method(self, attr_name)
  end

  def method_missing(name, *args)
    if name.match(/\A(.*)_with_tax\Z/)
      attr_name = name.to_s.sub(/_with_tax\Z/, '')
      WithTax::MethodDefiner.add_method(self.class, attr_name)
      send(name, *args)
    else
      super
    end
  end
end
