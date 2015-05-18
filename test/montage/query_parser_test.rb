require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/query_parser'

class Montage::QueryParserTest < Minitest::Test
  context "#get_column_name" do
    setup do
      @parser = Montage::QueryParser.new("foo")
    end

    should "get the column name from the string" do
      assert_equal "foo", @parser.get_column_name("foo = bar")
    end

    should "be able to parse a query string with no spaces in it" do
      assert_equal "foo", @parser.get_column_name("foo='bar'", "=")
    end
  end

  context "#get_query_operator" do
    setup do
      @parser = Montage::QueryParser.new("foo")
    end

    should "return the proper operator if found" do
      assert_equal ["!=", "__not"], @parser.get_query_operator("foo != 'bar'")
    end

    should "return nil if the proper operator cannot be found" do
      assert_equal [nil, nil], @parser.get_query_operator("foo fob 'bar'")
    end

    should "be able to grab the operator from a string with no spaces" do
      assert_equal ["!=", "__not"], @parser.get_query_operator("foo!='bar'")
    end

    should "get the ilike operator properly" do
      assert_equal ["ilike", "__icontains"], @parser.get_query_operator("foo ilike 'bar'")
    end
  end

  context "#parse_condition_set" do
    setup do
      @parser = Montage::QueryParser.new("foo")
    end

    should "return the condition set" do
      assert_equal "'foo'", @parser.parse_condition_set("bar = 'foo'")
      assert_equal "42", @parser.parse_condition_set("foo = 42")
      assert_equal "(1,2,3)", @parser.parse_condition_set("foo IN (1,2,3)")
      assert_equal "('a','b','c')", @parser.parse_condition_set("foo IN ('a','b','c')")
    end
  end

  context "#parse_part" do
    setup do
      @parser = Montage::QueryParser.new("foo")
    end

    should "properly parse the part" do
      assert_equal 42, @parser.parse_part("42")
      assert_equal 1.2, @parser.parse_part("1.2")
      assert_equal [1,2,3], @parser.parse_part("(1,2,3)")
      assert_equal "foo", @parser.parse_part("foo")
      assert_equal ["bar", "foo"], @parser.parse_part("[\"bar\", \"foo\"]")
    end
  end

  context "#get_parts" do
    setup do
      @parser = Montage::QueryParser.new("foo")
    end

    should "properly get all the parts" do
      assert_equal ["foo", "", "bar"], @parser.get_parts("foo = 'bar'")
      assert_equal ["foo", "__not", "bar"], @parser.get_parts("foo!=bar")
      assert_equal ["foo", "__includes", "[\"bar\"]"], @parser.get_parts("foo includes '[\"bar\"]'")
    end

    should "raise an exception if the query string doesn't have the right number of values" do
      assert_raises(Montage::QueryError, "Your query has an undetermined error") do
        Montage::QueryParser.new('').get_parts('')
      end
    end

    should "raise an exception if none of the operators match" do
      assert_raises(Montage::QueryError, "The operator you have used is not a valid Montage query operator") do
        Montage::QueryParser.new("foo <>< 'bar'").get_parts("foo sdjfk 'bar'")
      end
    end
  end

  context "#parse_hash" do
    context "with a single argument" do
      setup do
        @parser = Montage::QueryParser.new({foo: "bar"})
      end

      should "properly parse the query" do
        assert_equal({foo:"bar"}, @parser.parse_hash)
      end
    end

    context "with two arguments" do
      setup do
        @parser = Montage::QueryParser.new(foo: "bar", bar: [1,2,3])
      end

      should "properly parse the query" do
        assert_equal({foo:"bar", bar__in: [1,2,3]}, @parser.parse_hash)
      end
    end

    context "with multiple arguments" do
      setup do
        @parser = Montage::QueryParser.new(foo:42, bar: [1,2,3], foobar:50)
      end

      should "peoperly parse the query" do
        assert_equal({foo:42, bar__in: [1,2,3], foobar:50}, @parser.parse_hash)
      end
    end
  end

  context "#parse_string" do
    context "with a basic query" do
      setup do
        @parser = Montage::QueryParser.new("foo = 'bar'")
      end

      should "properly parse the query" do
        assert_equal({foo:"bar"}, @parser.parse_string)
      end
    end

    context "with an and statement" do
      setup do
        @parser = Montage::QueryParser.new("foo = 'bar' AND bar = 'foo'")
      end

      should "properly parse the query" do
        assert_equal({foo:"bar", bar:"foo"}, @parser.parse_string)
      end
    end

    context "with multiple and statements" do
      setup do
        @parser = Montage::QueryParser.new("foo='bar' and bar='foo' and foobar < 50")
      end

      should "properly parse the query" do
        assert_equal({foo:"bar", bar:"foo", foobar__lt: 50}, @parser.parse_string)
      end
    end
  end

  context "#parse" do
    should "properly parse a query that has IN in the search string" do
      assert_equal({foo__icontains: "kings"}, Montage::QueryParser.new("foo ilike 'kings'").parse)
    end

    should "properly parse a query that has the word and in the search string" do
      assert_equal({foo: "Fruit and Nut"}, Montage::QueryParser.new("foo = 'Fruit and Nut'").parse)
    end

    should "properly parse an = query" do
      assert_equal({ foo: "Foo Bar" }, Montage::QueryParser.new("foo = 'Foo Bar'").parse)
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

    should "properly parse an IN query using array syntax" do
      assert_equal({ foo__in: ["bar","barb","barber"] }, Montage::QueryParser.new({foo: ['bar','barb','barber']}).parse)
    end

    should "properly parse a = query with a float" do
      assert_equal({ foo__lte: 1.5 }, Montage::QueryParser.new("foo <= 1.5").parse)
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

    should "properly parse a LIKE query" do
      assert_equal({ foo__contains: "bar" }, Montage::QueryParser.new("foo LIKE 'bar'").parse)
    end

    should "properly parse an ILIKE query" do
      assert_equal({ foo__icontains: "bar" }, Montage::QueryParser.new("foo ILIKE 'bar'").parse)
    end

    should "properly parse an includes query" do
      assert_equal({ foo__includes: ["foo"]}, Montage::QueryParser.new("foo includes #{["foo"].to_json}").parse)
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
