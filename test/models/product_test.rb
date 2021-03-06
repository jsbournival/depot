require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:price].any?
  	assert product.errors[:image_url].any?
  end

  test "product nust have a title of at least 10 char" do
  	product = Product.new description: 'blah', price: 8, image_url: 'blah.jpg'

  	product.title = '123456789'
  	assert product.invalid?
  	assert_equal [I18n.translate("errors.messages.too_short", count: 10)], product.errors[:title]

  	product.title = "1234567890"
  	assert product.valid?
  	
  	product.title = "123456789023254364567756757674565345435"
  	assert product.valid?, "very long number should be valid"
  end


  test "product must have a valid price" do
  	product = Product.new title: 'test_test_test', description: 'test', image_url: 'test.jpg'
  	
  	product.price = 0.001
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

  	product.price = 'abc'
  	assert product.invalid?
  	assert_equal ["is not a number"], product.errors[:price]
  	
  	product.price = 1
  	assert product.valid?

  end

  def new_product (image_url) 
  	Product.new title: 'test_test_test', description: 'test', price: 1, image_url: image_url
  end

  test "image_url" do
  	ok = %w{ fred.gif fred.jpg fred.png FRED.PNG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
  	bad =  %w{ fred.doc fred.gif/more fred.gif.more }

  	ok.each do |name|
  		assert new_product(name).valid?, "#{name} shouldn't be invalid"
  	end

  	bad.each do |name|
  		assert new_product(name).invalid?, "#{name} shouldn't be valid"
  	end
  end

  test "product is not valid without a unique title" do
  	product = Product.new( 
  			title: products(:ruby).title,
  			description: 'blah',
  			price: 1,
  			image_url: "asdsd.jpg"
  	)

  	assert product.invalid?
  	assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
end
