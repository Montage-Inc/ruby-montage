require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/parser'

class Montage::ParserTest < Minitest::Test
  context "#parse_value" do
    setup do
      @parser = Montage::Parser.new
    end

    should "return an integer if the value is an integer" do
      assert_equal 1, @parser.parse_value("1",'test')
    end

    should "return a float if the value is a float" do
      assert_equal 1.2, @parser.parse_value("1.2",'test')
    end

    should "return a sanitized string if the value is a string" do
      assert_equal "foo", @parser.parse_value("'foo'",'test')
    end
  end

  context "#parse_string_clause" do

    should "raise an exception if the query string doesn't have the right number of values" do
      assert_raises(Montage::QueryError, "Your query has an undetermined error") do
        Montage::Parser.new('foo').parse
      end
    end

    should "raise an exception if none of the operators match" do
      assert_raises(Montage::QueryError, "The operator you have used is not a valid Montage query operator") do
        Montage::Parser.new("foo <>< 'bar'").parse
      end
    end

    should "properly parse an = query" do
      assert_equal({ foo: "bar" }, Montage::Parser.new("foo = 'bar'").parse)
    end

    should "properly parse a != query" do
      assert_equal({ foo__not: "bar" }, Montage::Parser.new("foo != 'bar'").parse)
    end

    should "properly parse a > query" do
      assert_equal({ foo__gt: "bar" }, Montage::Parser.new("foo > 'bar'").parse)
    end

    should "properly parse a >= query" do
      assert_equal({ foo__gte: "bar" }, Montage::Parser.new("foo >= 'bar'").parse)
    end

    should "properly parse a < query" do
      assert_equal({ foo__lt: "bar" }, Montage::Parser.new("foo < 'bar'").parse)
    end

    should "properly parse a <= query" do
      assert_equal({ foo__lte: "bar" }, Montage::Parser.new("foo <= 'bar'").parse)
    end

    should "properly parse an IN query" do
      assert_equal({ foo__in: ["bar","barb","barber"] }, Montage::Parser.new("foo IN (bar,barb,barber)").parse)
    end

    should "properly parse an NOT IN query" do
      assert_equal({ foo__notin: ["bar","barb","barber"] }, Montage::Parser.new("foo NOT IN (bar,barb,barber)").parse)
    end
    #
    # should "properly parse a CONTAINS query" do
    #   assert_equal({ foo__contains: "bar" }, @query.parse_string_clause("'bar' IN foo"))
    # end
  end
end