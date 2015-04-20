require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/query_parser'

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
      assert_equal({ foo: "foo bar" }, Montage::QueryParser.new("foo = 'foo bar'").parse)
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
      assert_equal({ foo__in: ["bar","barb","barber"] }, Montage::QueryParser.new("foo: [bar,barb,barber]").parse)
    end

    should "properly parse an IN query using array syntax" do
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

    should "properly parse a LIKE query" do
      assert_equal({ foo__contains: "bar" }, Montage::QueryParser.new("foo LIKE 'bar'").parse)
    end

    should "properly parse an ILIKE query" do
      assert_equal({ foo__icontains: "bar" }, Montage::QueryParser.new("foo ILIKE 'bar'").parse)
    end
  end

  context "#query_operator" do
    setup do
      @parser = Montage::QueryParser
    end

    should "return the operator and its montage equivalent" do
      assert_equal "__gte", @parser.new('test >= foo').query_operator
    end
  end

  context "#to_array" do
    setup do
      @parser = Montage::QueryParser.new("foo")
    end

    should "properly parse an array of integers" do
      assert_equal [1, 2, 3], @parser.to_array("(1,2,3)")
    end

    should "properly parse an array of floats" do
      assert_equal [1.0, 2.0, 3.0], @parser.to_array("(1.0,2.0,3.0)")
    end

    should "properly parse an array of strings" do
      assert_equal ["foo", "bar"], @parser.to_array("('foo','bar')")
    end

    should "coerce the entire array into integers if the first value is an integer" do
      assert_equal [1, 2, 0], @parser.to_array("(1,2.3,'foo')")
    end

    should "coerce the entire array into floats if the first value is a float" do
      assert_equal [1.0, 2.0, 0], @parser.to_array("(1.0,2,'foo')")
    end

    should "coerce the entire array into strings if the first value is a string" do
      assert_equal ["foo", "1", "2.3"], @parser.to_array("('foo',1,2.3)")
    end
  end
end
