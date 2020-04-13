require 'with_tax/version'
require 'with_tax/method_definer'

module WithTax
  class Error < StandardError; end

  def attr_with_tax(attr_name, option = {})
    WithTax::MethodDefiner.add_method(self, attr_name, option)
  end
end
