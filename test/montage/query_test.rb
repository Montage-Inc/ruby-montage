require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/query'

class Montage::QueryTest < Minitest::Test
  context "#nillify" do
    setup do
      @query = Montage::Query.new
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

  context "#is_i?" do
    setup do
      @query = Montage::Query.new
    end

    should "return false if a float is passed in" do
      assert !@query.is_i?("1.2")
    end

    should "return false if a string is passed in" do
      assert !@query.is_i?("foo")
    end

    should "return true if an integer is passed in" do
      assert @query.is_i?("1")
    end
  end

  context "#is_f?" do
    setup do
      @query = Montage::Query.new
    end

    should "return false if an integer is passed in" do
      assert !@query.is_f?("1")
    end

    should "return false if a string is passed in" do
      assert !@query.is_f?("foo")
    end

    should "return true if a float is passed in" do
      assert @query.is_f?("1.2")
    end
  end

  context "#limit" do
    setup do
      @query = Montage::Query.new
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
      @query = Montage::Query.new
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
      @query = Montage::Query.new
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

  context "#where" do
    setup do
      @query = Montage::Query.new
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
      @query = Montage::Query.new
    end

    should "parse the query to a json format" do
      assert_equal "{\"filter\":{\"foo\":1,\"bar__gt\":2},\"order\":\"created_at desc\",\"limit\":10}", @query.where(foo: 1).where("bar > 2").order(created_at: :desc).limit(10).to_json
    end
  end
end