require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/query'

class Montage::QueryTest < Minitest::Test
  context "initialization" do
    should "accept a schema attribute" do
      query = Montage::Query.new(schema: "bob_ross_paintings")

      assert_equal "bob_ross_paintings", query.schema
    end

    should "disallow post-init mutation on the schema attribute" do
      query = Montage::Query.new(schema: "bob_ross_paintings")

      assert_raises(NoMethodError) do
        query.schema = "not_so_fast_my_friend"
      end
    end

    should "raise an exception if the schema attribute is missing" do
      assert_raises(Montage::InvalidAttributeFormat) do
        Montage::Query.new
      end
    end

    should "raise an exception if the schema attribute is not a string" do
      assert_raises(Montage::InvalidAttributeFormat) do
        Montage::Query.new(schema: :happy_little_trees)
      end
    end

    should "raise an exception if the schema attribute contains invalid characters" do
      assert_raises(Montage::InvalidAttributeFormat) do
        Montage::Query.new(schema: "happy accident")
      end
    end
  end

  context "#merge_array" do
    setup do
      @query = Montage::Query.new(schema: "bob_ross_paintings")
      @query_param = ["$ReQON", 1]
    end

    should "merge a non-existent parameter into the query options" do
      @expected = {
        "$schema" => "bob_ross_paintings",
        "$query" => [
          ["$filter", []],
          ["$ReQON", 1]
        ]
      }

      @query.merge_array(@query_param)
      assert_equal @expected, @query.options
    end

    should "find and replace an existing query parameter" do
      @query.options = {
        "$schema" => "bob_ross_paintings",
        "$query" => [
          ["$filter", []],
          ["$ReQON", "value_to_be_replaced"]
        ]
      }

      @expected = {
        "$schema" => "bob_ross_paintings",
        "$query" => [
          ["$filter", []],
          ["$ReQON", 1]
        ]
      }

      @query.merge_array(@query_param)
      assert_equal @expected, @query.options
    end
  end

  context "#limit" do
    setup do
      @query = Montage::Query.new(schema: "bob_ross_paintings")
    end

    should "append the limit attribute to the query body" do
      @expected = [["$filter", []], ["$limit", 10]]

      assert_equal @expected, @query.limit(10).options["$query"]
    end

    should "replace existing limit attributes" do
      @expected = [["$filter", []], ["$limit", 99]]

      assert_equal @expected, @query.limit(1).limit(99).options["$query"]
    end

    should "set the default to nil" do
      @expected = [["$filter", []], ["$limit", nil]]

      assert_equal @expected, @query.limit.options["$query"]
    end
  end

  context "#offset" do
    setup do
      @query = Montage::Query.new(schema: "bob_ross_paintings")
    end

    should "append the offset attribute to the query body" do
      @expected = [["$filter", []], ["$offset", 14]]

      assert_equal @expected, @query.offset(14).options["$query"]
    end

    should "replace existing offset attributes" do
      @expected = [["$filter", []], ["$offset", 14]]

      assert_equal @expected, @query.offset(1).offset(14).options["$query"]
    end

    should "set the default to nil" do
      @expected = [["$filter", []], ["$offset", nil]]

      assert_equal @expected, @query.offset.options["$query"]
    end
  end

  context "#order" do
    setup do
      @query = Montage::Query.new(schema: "bob_ross_paintings")
      @expected = [["$filter", []], ["$order_by", ["$asc", "foo"]]]
    end

    should "append the order attribute to the query body" do
      assert_equal @expected, @query.order("foo asc").options["$query"]
    end

    should "set the default sort order to asc if not passed in" do
      assert_equal @expected, @query.order("foo").options["$query"]
    end

    should "accept and properly parse a hash" do
      assert_equal @expected, @query.order(foo: :asc).options["$query"]
    end
  end

  # context "#where" do
  #   setup do
  #     @query = Montage::Query.new(schema: "bob_ross_paintings")
  #   end
  #
  #   should "append the filter to the query body" do
  #     expected = {
  #       "$schema" => "bob_ross_paintings",
  #       "$query" => [
  #         "$filter" => [
  #           foo__lte: 1
  #         ]
  #       ]
  #     }
  #
  #     assert_equal expected, @query.where("foo <= 1").query
  #   end
  #
  #   should "work with AND operator" do
  #     expected = {
  #       "$schema" => "bob_ross_paintings",
  #       "$query" => {
  #         "$filter" => {
  #           foo__lt: 5,
  #           foo__gt: 3
  #         }
  #       }
  #     }
  #
  #     assert_equal expected, @query.where("foo < 5 AND foo > 3").query
  #   end
  # end

  context "#index" do
    setup do
      @query = Montage::Query.new(schema: "bob_ross_paintings")
    end

    should "append the index to the query body" do
      expected = {
        "$schema" => "bob_ross_paintings",
        "$query" => [
          ["$filter", []],
          ["$index", "foo"]
        ]
      }

      assert_equal expected, @query.index("foo").options
    end
  end
  #
  # context "#pluck" do
  #   setup do
  #     @query = Montage::Query.new(schema: "bob_ross_paintings")
  #   end
  #
  #   should "append pluck to the query body" do
  #     expected = {
  #       "$schema" => "bob_ross_paintings",
  #       "$query" => [
  #         ["$filter", []],
  #         ["$pluck", "id"]
  #       ]
  #     }
  #
  #     assert_equal expected, @query.pluck("id").query
  #   end
  #
  #   should "accept a symbol" do
  #     expected = {
  #       "$schema" => "bob_ross_paintings",
  #       "$query" => [
  #         ["$filter", []],
  #         ["$pluck", "id"]
  #       ]
  #     }
  #
  #     assert_equal expected, @query.pluck(:id).query
  #   end
  # end
  #
  context "#select" do
    setup do
      @query = Montage::Query.new(schema: "bob_ross_paintings")
    end

    should "accept any number of parameters" do
      expected = {
        "$schema" => "bob_ross_paintings",
        "$query" => [
          ["$filter", []],
          ["$pluck", %w(id name)]
        ]
      }

      assert_equal expected, @query.select("id", "name").options
    end

    should "accept symbols" do
      expected = {
        "$schema" => "bob_ross_paintings",
        "$query" => [
          ["$filter", []],
          ["$pluck", %w(id name email)]
        ]
      }

      assert_equal expected, @query.select(:id, :name, :email).options
    end
  end

  context "#to_json" do
    setup do
      @query = Montage::Query.new(schema: "test")
    end

    should "parse the query to a json format" do
      expected = "{\"$schema\":\"test\",\"$query\":[[\"$filter\",[]]]}"

      assert_equal expected, @query.to_json
    end
  end
end
