##########Representation of a tax authority with powers to set basic sales tax, import duty and to define the tax exemption list
class Taxman
  attr_accessor :sales_tax, :import_duty, :exempt_basic

  def initialize(sales_tax, import_duty, exempt_basic)
    @sales_tax = sales_tax
    @import_duty = import_duty
    @exempt_basic = exempt_basic
  end

  #Describes current tax rates and gives a list of exempt products
  def to_s
    "Taxes: #{@sales_tax}% of basic sales tax on all goods except #{exempt_basic}.\n" + 
    "#{@import_duty}% of import duty on all imported goods"
  end
end

##########Representation of taxable products
class Item
  attr_reader :name, :is_imported, :taxes
  attr_accessor :price

  def initialize(name, price, type, is_imported)
    @name = name
    @price = price
    @type = type
    @is_imported = is_imported
  end

  #Calculates corresponding tax total depending on properties and current rates set by tax authority
  def apply_taxes(taxman)
    @taxes = 0
    if @is_imported
      @taxes += taxman.import_duty
    end
    unless taxman.exempt_basic.include?(@type)
      @taxes += taxman.sales_tax
    end
  end

  #Full description of the item's state, with price including taxes
  def to_s
    "#{@name} at #{@price + (@price * @taxes / 100.0)}"
    if @is_imported
      'imported ' + description
    end 
  end
end

##########Shopping cart with receipt printing capabilities
class Cart
  attr_accessor :cart

  def initialize
    #Hash of item-quantity pairs
    @cart = {}
  end

  #Prints out the list of purchased items along with their price including taxes
  def to_s
    @cart.each do |item, quantity|
      "#{quantity} #{item}\n"
    end
  end

  #Calculates and prints out total amount of taxes for all listed items
  def total_taxes
    total_taxes = 0;
    @cart.each do |item, quantity|
      total_taxes += item.taxes
    end
    puts "Sales taxes: #{total_taxes}"
  end

  #Convenience method that prints out standard receipt, including subtotal of taxes
  def checkout
    to_s
    total_taxes
  end 
end