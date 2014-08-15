#Note: class design loosely based on StackOverflow answer: http://stackoverflow.com/questions/14973770/object-oriented-design#answers

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
    @price += (@price * @taxes / 5.0).round / 20.0
  end

  #Full description of the item's state, with price including taxes ((x * 20).round / 20.0 => rounding up to nearest 0.05)
  def to_s
    "#{@name} at #{@price}"
    if @is_imported
      'imported ' + description
    end 
  end
end

##########Shopping cart with receipt printing capabilities
class Cart
  attr_accessor :list

  def initialize
    #Hash of item-quantity pairs
    @list = {}
  end

  #Prints out the list of purchased items along with their price including taxes
  def to_s
    @list.each do |item, quantity|
      "#{quantity} #{item}\n"
    end
  end

  #Calculates and prints out total amount of taxes for all listed items
  def total_taxes
    total_taxes = 0;
    @list.each do |item, quantity|
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

ontario_tax = Taxman.new(10, 5, ['books', 'food', 'medical'])
book = Item.new('book', '12.49', 'books', false)
loblaws_cart = Cart.new
loblaws_cart.list = {book => 1}
loblaws_cart.checkout