require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/parser'

class Montage::QueryParserTest < Minitest::Test
  context "#parse_string_clause" do

    should "raise an exception if the query string doesn't have the right number of values" do
      assert_raises(Montage::QueryError, "Your query has an undetermined error") do
        Montage::QueryParser.new('foo').parse
      end
    end

    should "raise an exception if none of the operators match" do
      assert_raises(Montage::QueryError, "The operator you have used is not a valid Montage query operator") do
        Montage::QueryParser.new("foo <>< 'bar'").parse
      end
    end

    should "properly parse an = query" do
      assert_equal({ foo: "bar" }, Montage::QueryParser.new("foo = 'bar'").parse)
    end

    should "properly parse a != query" do
      assert_equal({ foo__not: "bar" }, Montage::QueryParser.new("foo != 'bar'").parse)
    end

    should "properly parse a > query" do
      assert_equal({ foo__gt: "bar" }, Montage::QueryParser.new("foo > 'bar'").parse)
    end

    should "properly parse a >= query" do
      assert_equal({ foo__gte: "bar" }, Montage::QueryParser.new("foo >= 'bar'").parse)
    end

    should "properly parse a < query" do
      assert_equal({ foo__lt: "bar" }, Montage::QueryParser.new("foo < 'bar'").parse)
    end

    should "properly parse a <= query" do
      assert_equal({ foo__lte: "bar" }, Montage::QueryParser.new("foo <= 'bar'").parse)
    end

    should "properly parse an IN query" do
      assert_equal({ foo__in: ["bar","barb","barber"] }, Montage::QueryParser.new("foo IN (bar,barb,barber)").parse)
    end

    should "properly parse an NOT IN query" do
      assert_equal({ foo__notin: ["bar","barb","barber"] }, Montage::QueryParser.new("foo NOT IN (bar,barb,barber)").parse)
    end

    should "make all items a string if first item is a string" do
      assert_equal({ foo__notin: ["bar","barb","barber","1"] }, Montage::QueryParser.new("foo NOT IN (bar,barb,barber,1)").parse)
    end

    should "make all items an int if first item is an int" do
      assert_equal({ foo__notin: [1,2,0,0] }, Montage::QueryParser.new("foo NOT IN (1,2,'test','lol')").parse)
    end
    should "make all items a float if first item is a float" do
      assert_equal({ foo__notin: [1.4,2,0,0] }, Montage::QueryParser.new("foo NOT IN (1.4,2,'test','lol')").parse)
    end
    #
    # should "properly parse a CONTAINS query" do
    #   assert_equal({ foo__contains: "bar" }, @query.parse_string_clause("'bar' IN foo"))
    # end
    context "#get_operator" do
      setup do
        @parser = Montage::QueryParser
      end

      should "return the operator and its montage equivalent" do
        assert_equal [">=", "__gte"], @parser.new('test >= foo').query_operator
      end
    end
  end
end