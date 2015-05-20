require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/query'

class Montage::QueryTest < Minitest::Test
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
      @expected = { filter: {}, order_by: "foobar",ordering: "asc" }
    end

    should "append the order attribute to the query body" do
      assert_equal @expected, @query.order("foobar asc").query
    end

    should "set the default sort order to asc if not passed in" do
      assert_equal @expected, @query.order("foobar").query
    end

    should "set the order to empty" do
      assert_equal({ filter: {}, order_by: "",ordering: "" }, @query.order.query)
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

    should "work with AND operator" do
      expected = {
        filter: {
          foo__lt: 5.0,
          foo__gt: 3.0
        }
      }

      assert_equal expected, @query.where("foo < 5 AND foo > 3").query
    end
  end

  context "#index" do
    setup do
      @query = Montage::Query.new
    end

    should "append the index to the query body" do
      expected = { filter: {}, index: "foo" }

      assert_equal expected, @query.index("foo").query
    end
  end

  context "#pluck" do
    setup do
      @query = Montage::Query.new
    end

    should "append pluck to the query body" do
      expected = { filter: {}, pluck: ["id"] }

      assert_equal expected, @query.pluck("id").query
    end

    should "accept a symbol" do
      expected = { filter: {}, pluck: ["id"] }

      assert_equal expected, @query.pluck(:id).query
    end
  end

  context "#select" do
    setup do
      @query = Montage::Query.new
    end

    should "accept any number of parameters" do
      expected = { filter: {}, pluck: ["id", "name"] }

      assert_equal expected, @query.select("id", "name").query
    end

    should "accept symbols" do
      expected = { filter: {}, pluck: ["id", "name", "email"] }

      assert_equal expected, @query.select(:id, :name, :email).query
    end
  end

  context "#to_json" do
    setup do
      @query = Montage::Query.new
    end

    should "parse the query to a json format" do
      assert_equal "{\"filter\":{\"foo\":1,\"bar__gt\":2},\"order_by\":\"created_at\",\"ordering\":\"desc\",\"limit\":10}", @query.where(foo: 1).where("bar > 2").order(created_at: :desc).limit(10).to_json
    end
  end
end
