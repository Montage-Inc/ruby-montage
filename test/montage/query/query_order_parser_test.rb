require File.dirname(__FILE__) + '/../../minitest_helper.rb'
require 'montage/query/order_parser'

class Montage::OrderParserTest < Minitest::Test
  context "initialization" do
    should "accept a clause argument" do
      @order_parser = Montage::OrderParser.new(paintings: "asc")

      assert_equal({ paintings: "asc" }, @order_parser.clause)
    end

    should "raise an error if direction is not defined in a hash clause" do
      assert_raises(Montage::ClauseFormatError) do
        Montage::OrderParser.new(im_not_direction: "me neither")
      end
    end

    should "raise an error if a string clause is empty" do
      assert_raises(Montage::ClauseFormatError) do
        Montage::OrderParser.new(" ")
      end
    end
  end

  context "#parse" do
    setup do
      @expected = ["$order_by", ["$asc", "foo"]]
    end

    should "parse a hash and return a valid ReQON array" do
      @order_parser = Montage::OrderParser.new(foo: "asc")

      assert_equal @expected, @order_parser.parse
    end

    should "parse a string and return a valid ReQON array" do
      @order_parser = Montage::OrderParser.new("foo asc")

      assert_equal @expected, @order_parser.parse
    end

    should "default direction to asc when absent in a string clause" do
      @order_parser = Montage::OrderParser.new("foo")

      assert_equal @expected, @order_parser.parse
    end

    should "default direction to asc when incorrect in a string clause" do
      @order_parser = Montage::OrderParser.new("foo sadie")

      assert_equal @expected, @order_parser.parse
    end
  end
end
