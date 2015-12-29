require 'montage/errors'
require 'montage/query/query_parser'
require 'montage/query/order_parser'
require 'montage/support'
require 'json'

module Montage
  class Query
    include Montage::Support

    attr_accessor :options
    attr_reader :schema

    # Initializes the query instance via a params hash
    #
    # * *Attributes* :
    #   - +schema+ -> The name of the schema you wish to query.  Alphanumeric
    #     characters and underscores are allowed.
    #   - +options+ -> A query hash containing desired options
    # * *Returns* :
    #   - A valid Montage::Query instance
    # * *Raises* :
    #   - +InvalidAttributeFormat+ -> If the declared schema is not a string or
    #     contains non-alphanumeric characters.  Underscore ("_") is allowed!
    # * *Examples* :
    #    @query = Montage::Query.new(schema: 'testing')
    #    => <Montage::Query:ID @query={"$schema"=>"testing", "$query"=>[["$filter", []]]}, @schema="testing">
    #
    def initialize(params = {})
      @schema = params[:schema]
      @options = {
        "$schema" => @schema,
        "$query" => [
          ["$filter", []]
        ]
      }
      fail(
        InvalidAttributeFormat, "Schema attribute must be declared and valid!"
      ) unless schema_valid?
    end

    # Validates the Montage::Query schema attribute
    #
    # * *Returns* :
    #   - A boolean
    #
    def schema_valid?
      @schema.is_a?(String) && @schema.index(/\W+/).nil?
    end

    # Adds a query parameter to Montage::Query instances in the form of
    # an array. Checks for existing array elements and replaces them if found.
    #
    # * *Args* :
    #   - +query_param+ -> A query-modifing parameter in the form of an array.
    #     Composed of a ReQON supported string as a designator and an
    #     associated value.
    #
    # * *Returns* :
    #   - The updated array
    #
    def merge_array(query_param)
      arr = options["$query"]
      position = arr.index(arr.assoc(query_param[0]))

      if position.nil?
        arr.push(query_param)
      else
        arr[position] = query_param
      end
    end

    # Defines the limit to apply to the query, defaults to nil
    #
    # * *Args* :
    #   - +max+ -> The max number of desired results
    # * *Returns* :
    #   - An updated copy of self
    # * *Examples* :
    #    @query.limit(99).options
    #    => {"$schema"=>"testing", "$query"=>[["$filter", []], ["$limit", 99]]}
    #
    def limit(max = nil)
      clone.tap { |r| r.merge_array(["$limit", max]) }
    end

    # Defines the offset to apply to the query, defaults to nil
    #
    # * *Args* :
    #   - +value+ -> The desired offset value
    # * *Returns* :
    #   - An updated copy of self
    # * *Examples* :
    #    @query.offset(14).options
    #    => {"$schema"=>"testing", "$query"=>[["$filter", []], ["$offset", 14]]}
    #
    def offset(value = nil)
      clone.tap { |r| r.merge_array(["$offset", value]) }
    end

    # Defines the order clause for the query and merges it into the query hash
    #
    # * *Args* :
    #   - +clause+ -> A hash or string value containing the field to order by
    #     and the direction.  Valid directions are "asc" and "desc".  String
    #     values will default to "asc" if omitted or incorrect.
    # * *Returns* :
    #   - An updated copy of self
    # * *Examples* :
    #   - String
    #    @query.order("foo asc").options
    #    => {"$schema"=>"testing", "$query"=>[["$filter", []], ["$order_by", ["$asc", "foo"]]]}
    #   - Hash
    #    @query.order(:foo => :asc).options
    #    => {"$schema"=>"testing", "$query"=>[["$filter", []], ["$order_by", ["$asc", "foo"]]]}
    #
    def order(clause = {})
      clone.tap { |r| r.merge_array(OrderParser.new(clause).parse) }
    end

    # Parses the SQL string passed into the method
    #
    # Raises an exception if it is not a valid query (at least three "words"):
    #   parse_string_clause("foo bar")
    #
    # Raises an exception if the operator given is not a valid operator
    #   parse_string_clause("foo * 'bar'")
    #
    # Returns a hash:
    #   parse_string_clause("foo <= 1")
    #   => { foo__lte: 1.0 }
    #

    # Adds a where clause to the query filter hash
    #
    # * *Args* :
    #   - +clause+ -> A hash or string containing desired options
    # * *Example* :
    #   - where(foo: 1)
    #   - where("foo > 1")
    # * *Returns* :
    #   - A copy of self
    #
    def where(clause)
      clone.tap { |r| r.merge_array(["$filter", QueryParser.new(clause).parse]) }
    end

    # Select a set of columns from the result set
    #
    # * *Args* :
    #   - +Array+ -> Accepts multiple column names as a string or symbol
    # * *Example* :
    #   - select(:id, :user_name)
    #   - select("column_name")
    # * *Returns* :
    #   - A copy of self
    #
    def select(*args)
      clone.tap { |r| r.query.merge!(pluck: args.map(&:to_s)) }
    end

    # Specifies an index to use on a query.
    #
    # * *Notes* :
    #   - RethinkDB isn't as smart as some other database engines when selecting
    #     a query plan, but it does let you specify which index to use
    # * *Args* :
    #   - +field+ -> The index value in string format
    # * *Example* :
    #   - index("value")
    # * *Returns* :
    #   - A copy of self
    #
    def index(field)
      clone.tap { |r| r.query.merge!(index: field) }
    end

    # Pluck just one column from the result set
    #
    # * *Args* :
    #   - +column_name+ -> Accepts a single string or symbol value for the column
    # * *Example* :
    #   - pluck(:id)
    #   - pluck("column_name")
    # * *Returns* :
    #   - A copy of self
    #
    def pluck(column_name)
      clone.tap { |r| r.query.merge!(pluck: [column_name.to_s]) }
    end

    # Parses the current query hash and returns a JSON string
    #
    def to_json
      @options.to_json
    end
  end
end
