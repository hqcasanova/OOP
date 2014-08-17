#Note: class design loosely based on StackOverflow answer: http://stackoverflow.com/questions/14973770/object-oriented-design#answers

require 'bigdecimal'
MONEY_FORMAT = '$%.02f'

##########Representation of a tax authority with powers to set basic sales tax, import duty and to define the tax exemption list
class Taxman
  attr_accessor :sales_tax, :import_duty, :exempt_basic   #taxes change over time
  attr_reader :name

  def initialize(authority, sales_tax, import_duty, exempt_basic)
    @authority = authority
    @sales_tax = BigDecimal.new(sales_tax)
    @import_duty = BigDecimal.new(import_duty)
    @exempt_basic = exempt_basic
  end

  #Calculate tax for a given price tag
  def apply_tax(price, tax)
    return (price * tax / BigDecimal.new(5)).round / BigDecimal.new(20)   #rounding up to nearest 0.05
  end

  #Describes current tax rates and gives a list of exempt products
  def to_s
    "Tax authority: #{@authority}\n" +
    "-Sales Taxes: #{@sales_tax.to_i}% rate on all goods except #{exempt_basic}.\n" + 
    "-Import Duty: #{@import_duty.to_i}% rate on all imported goods."
  end
end

##########Representation of taxable products
class Item
  attr_reader :name, :is_imported, :taxes
  attr_accessor :price

  def initialize(name, type, is_imported)
    @is_imported = is_imported
    new_name = name
    if is_imported
      new_name = 'imported ' + new_name
    end
    @name = new_name
    @price = BigDecimal.new(0)
    @taxes = BigDecimal.new(0)
    @type = type
  end

  #Calculates corresponding tax total depending on properties and current rates set by tax authority
  def apply_taxes(taxman)
    @taxes = BigDecimal.new(0)
    if @is_imported
      @taxes += taxman.apply_tax(@price, taxman.import_duty)
    end
    unless taxman.exempt_basic.include?(@type)
      @taxes += taxman.apply_tax(@price, taxman.sales_tax)
    end
    @price += @taxes
  end

  #Full description of the item's state, with price including taxes
  def to_s
    "#{@name} at #{MONEY_FORMAT % @price}" 
  end
end

##########Shopping cart with receipt printing capabilities
class Cart
  attr_accessor :list   #Hash of item-quantity pairs
  attr_reader :total    #Total price of purchased items (with/out taxes)

  def initialize
    @list = {}
  end

  #Lists the cart's items with their respective prices before taxes
  def to_s
    printed_list = ""
    @list.each do |item, quantity|
      printed_list += "#{quantity} #{item}\n"
    end
    return printed_list
  end

  #Prints out the list of purchased items along with their price including taxes
  def after_taxes
    printed_list = ""
    @total = 0
    @list.each do |item, quantity|
      item_total = quantity * item.price
      @total += item_total
      printed_list += "#{quantity} #{item.name}: #{MONEY_FORMAT % item.price}\n"
    end
    return printed_list
  end

  #Calculates and prints out total amount of taxes for all listed items
  def total_taxes
    @total_taxes = 0
    @list.each do |item, quantity|
      @total_taxes += quantity * item.taxes
    end
    puts "Sales Taxes: #{MONEY_FORMAT % @total_taxes}"
  end

  #Convenience method that prints out standard receipt, including subtotal of taxes
  def checkout(receipt_name)
    puts receipt_name
    puts after_taxes
    total_taxes
    puts "Total: #{MONEY_FORMAT % @total}\n"
  end
end

#Sets up a tax authority and describes it
ontario = Taxman.new('Government of Ontario', 10, 5, ['books', 'food', 'medical'])
puts "#{ontario}\n"

#Creates items and cart
book = Item.new('book', 'books', false)
cd = Item.new('music CD', 'music', false)
chocbar = Item.new('chocolate bar', 'food', false)
chocolates = Item.new('box of chocolates', 'food', true)
perfume = Item.new('bottle of perfume', 'cosmetics', false)
perfume_imported = Item.new('bottle of perfume', 'cosmetics', true)
pills = Item.new('packet of headache pills', 'medical', false)
loblaws_cart = Cart.new

#Loblaws visit 1
puts "\nCart 1:"
book.price = BigDecimal.new('12.49')
cd.price = BigDecimal.new('14.99')
chocbar.price = BigDecimal.new('0.85')
loblaws_cart.list = {book => 1, cd => 1, chocbar => 1}
puts "#{loblaws_cart}"

#Checkout 1 
book.apply_taxes(ontario)
cd.apply_taxes(ontario)
chocbar.apply_taxes(ontario)
loblaws_cart.checkout("\nReceipt 1:")

#Loblaws visit 2
puts "\nCart 2:"
chocolates.price = BigDecimal.new('10.00')
perfume_imported.price = BigDecimal.new('47.50')
loblaws_cart.list = {chocolates => 1, perfume_imported => 1}
puts "#{loblaws_cart}"

#Checkout 2
chocolates.apply_taxes(ontario)
perfume_imported.apply_taxes(ontario)
loblaws_cart.checkout("\nReceipt 2:")

#Loblaws visit 3
puts "\nCart 3"
perfume_imported.price = BigDecimal.new('27.99')
perfume.price = BigDecimal.new('18.99')
pills.price = BigDecimal.new('9.75')
chocolates.price = BigDecimal.new('11.25')
loblaws_cart.list = {perfume_imported => 1, perfume => 1, pills => 1, chocolates => 1}
puts "#{loblaws_cart}"

#Checkout 3
perfume_imported.apply_taxes(ontario)
perfume.apply_taxes(ontario)
pills.apply_taxes(ontario)
chocolates.apply_taxes(ontario)
loblaws_cart.checkout("\nReceipt 3:")