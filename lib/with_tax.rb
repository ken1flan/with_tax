require 'with_tax/version'
require 'with_tax/method_definer'

module WithTax
  class Error < StandardError; end

  def method_missing(name, *args)
    if name.match(/\A(.*)_with_tax\Z/)
      WithTax::MethodDefiner.add_method(self.class, name)
      send(name, *args)
    else
      super
    end
  end
end
