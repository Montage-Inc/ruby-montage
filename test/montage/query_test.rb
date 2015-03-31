require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/query'

class Montage::QueryTest < Minitest::Test
  context "#nillify" do
    setup do
      @query = Montage::Query.new("foo")
    end

    should "return the string if not empty" do
      assert_equal "foo", @query.nillify("foo")
    end

    should "return nil if the string is empty" do
      assert_nil @query.nillify("")
    end

    should "return the number if it is not zero" do
      assert_equal 9, @query.nillify(9)
    end

    should "return nil if the number is zero" do
      assert_nil @query.nillify(0)
    end
  end

  context "#is_a_number?" do
    setup do
      @query = Montage::Query.new("foo")
    end

    should "return true if it is a number" do
      assert @query.is_a_number?("9.4")
    end

    should "return false if it is not a number" do
      assert !@query.is_a_number?("'foobar'")
    end
  end

  context "#limit" do
    setup do
      @query = Montage::Query.new("foo")
      @expected = { filter: {}, limit: 10 }
    end

    should "append the limit attribute to the query body" do
      assert_equal @expected, @query.limit(10).query
    end

    should "set the default to nil" do
      assert_equal({filter: {}, limit: nil}, @query.limit.query)
    end
  end

  context "#offset" do
    setup do
      @query = Montage::Query.new("foo")
      @expected = { filter: {}, offset: 10 }
    end

    should "append the offset attribute to the query body" do
      assert_equal @expected, @query.offset(10).query
    end

    should "set the default to nil" do
      assert_equal({ filter: {}, offset: nil }, @query.offset.query)
    end
  end

  context "#order" do
    setup do
      @query = Montage::Query.new("foo")
      @expected = { filter: {}, order: "foobar asc" }
    end

    should "append the order attribute to the query body" do
      assert_equal @expected, @query.order("foobar asc").query
    end

    should "set the default sort order to asc if not passed in" do
      assert_equal @expected, @query.order("foobar").query
    end

    should "set the default to nil" do
      assert_equal({ filter: {}, order: nil }, @query.order.query)
    end

    should "accept and properly parse a hash" do
      assert_equal @expected, @query.order(foobar: :asc).query
    end
  end

  context "#parse_string_clause" do
    setup do
      @query = Montage::Query.new("foo")
    end

    should "raise an exception if the query string doesn't have the right number of values" do
      assert_raises(Montage::QueryError, "Your query has an undetermined error") do
        @query.parse_string_clause("foo")
      end
    end

    should "raise an exception if none of the operators match" do
      assert_raises(Montage::QueryError, "The operator you have used is not a valid Montage query operator") do
        @query.parse_string_clause("foo <>< 'bar'")
      end
    end

    should "properly parse an = query" do
      assert_equal({ foo: "bar" }, @query.parse_string_clause("foo = 'bar'"))
    end

    should "properly parse a != query" do
      assert_equal({ foo__not: "bar" }, @query.parse_string_clause("foo != 'bar'"))
    end

    should "properly parse a > query" do
      assert_equal({ foo__gt: "bar" }, @query.parse_string_clause("foo > 'bar'"))
    end

    should "properly parse a >= query" do
      assert_equal({ foo__gte: "bar" }, @query.parse_string_clause("foo >= 'bar'"))
    end

    should "properly parse a < query" do
      assert_equal({ foo__lt: "bar" }, @query.parse_string_clause("foo < 'bar'"))
    end

    should "properly parse a <= query" do
      assert_equal({ foo__lte: "bar" }, @query.parse_string_clause("foo <= 'bar'"))
    end

    should "properly parse an IN query" do
      assert_equal({ foo__in: "bar,barb,barber" }, @query.parse_string_clause("foo IN (bar,barb,barber)"))
    end
    #
    # should "properly parse a CONTAINS query" do
    #   assert_equal({ foo__contains: "bar" }, @query.parse_string_clause("'bar' IN foo"))
    # end
  end

  context "#where" do
    setup do
      @query = Montage::Query.new("foo")
    end

    should "append the filter to the query body" do
      expected = {
        filter: {
          foo__lte: 1.0
        }
      }

      assert_equal expected, @query.where("foo <= 1").query
    end
  end

  context "#to_json" do
    setup do
      @query = Montage::Query.new("foo")
    end

    should "parse the query to a json format" do
      assert_equal "{\"filter\":{\"foo\":1,\"bar__gt\":2.0},\"order\":\"created_at desc\",\"limit\":10}", @query.where(foo: 1).where("bar > 2").order(created_at: :desc).limit(10).to_json
    end
  end
end