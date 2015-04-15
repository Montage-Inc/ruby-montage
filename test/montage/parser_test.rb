require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/parser'

class Montage::ParserTest < Minitest::Test
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
    context "#get_operator" do
      setup do
        @parser = Montage::Parser
      end

      should "return the operator and its montage equivalent" do
        assert_equal [">=", "__gte"], @parser.new('test >= foo').query_operator
      end
    end
  end
end