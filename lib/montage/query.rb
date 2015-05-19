require 'montage/errors'
require 'montage/query_parser'
require 'montage/support'
require 'json'

module Montage
  class Query
    include Montage::Support

    attr_accessor :query

    def initialize
      @query = { filter: {} }
    end

    # Defines the limit to apply to the query, defaults to nil
    #
    # Merges a hash:
    #  { limit: 10 }
    #
    # Returns self
    #
    def limit(max = nil)
      clone.tap { |r| r.query.merge!(limit: max) }
    end

    # Defines the offset to apply to the query, defaults to nil
    #
    # Merges a hash:
    #   { offset: 10 }
    #
    # Returns a copy of self
    #
    def offset(value = nil)
      clone.tap { |r| r.query.merge!(offset: value) }
    end

    # Defines the order clause for the query and merges it into the query hash
    #
    # Accepts either a string or a hash:
    #   order("foo asc") or
    #   order(:foo => :asc) or
    #   order(:foo => "asc")
    #
    # Defaults the direction to asc if no value is passed in for that, or if it is not a valid value
    #
    # Merges a hash:
    #   { order: "foo asc" }
    #
    # Returns a copy of self
    #
    def order(clause = {})
      if clause.is_a?(Hash)
        direction = clause.values.first.to_s
        field = clause.keys.first.to_s
      else
        direction = clause.split(" ")[1]
        field = clause.split(" ")[0]
        direction = "asc" unless %w(asc desc).include?(direction)
      end

      clone.tap{ |r| r.query.merge!(order_by: field, ordering: direction) }
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
    # Accepts either a Hash or a String
    #     where(foo: 1)
    #     where("foo > 1")
    #
    # Merges a hash:
    #   { foo: 1 }
    #
    # Returns a copy of self
    #
    def where(clause)
      clone.tap { |r| r.query[:filter].merge!(QueryParser.new(clause).parse) }
    end

    # Specifies and index to use on a query. RethinkDB isn't as smart as some other
    # database engines when selecting a query plan, but it does let you specify
    # which index to use
    #
    def index(field)
      clone.tap { |r| r.query.merge!(index: field) }
    end

    # Pluck just one column from the result set
    #
    def pluck(column_name)
      clone.tap { |r| r.query.merge!(pluck: column_name) }
    end

    # Parses the current query hash and returns a JSON string
    #
    def to_json
      @query.to_json
    end
  end
end
