require 'montage/errors'
require 'montage/parser'
require 'json'

module Montage
  class Query
    # Currently the Montage wrapper only supports the following operators
    #
    OPERATOR_MAP = {
      "=" => "",
      "!=" => "__not",
      ">" => "__gt",
      ">=" => "__gte",
      "<" => "__lt",
      "<=" => "__lte",
      "in" => "__in"
    }

    attr_accessor :query

    def initialize
      @query = { filter: {} }
    end

    # Defines the limit to apply to the query, defaults to nil
    #
    # Merges a hash:
    #  { limit: 10 }
    #
    # Returns a reference to self
    #
    def limit(max = nil)
      @query.merge!(limit: max)
      self
    end

    # Defines the offset to apply to the query, defaults to nil
    #
    # Merges a hash:
    #   { offset: 10 }
    #
    # Returns a reference to self
    #
    def offset(value = nil)
      @query.merge!(offset: value)
      self
    end

    # Will take either an empty string or zero and turn it into a nil object
    # If the value passed in is neither zero or an empty string, will return the value
    #
    def nillify(value)
      return value unless ["", 0].include?(value)
      nil
    end

    # Determines if the string value passed in is an integer
    # Returns true or false
    #
    def is_i?(value)
      /\A\d+\z/ === value
    end

    # Determines if the string value passed in is a float
    # Returns true or false
    #
    def is_f?(value)
      /\A\d+\.\d+\z/ === value
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
    # Returns a reference to self
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

      @query.merge!(order: nillify("#{field} #{direction}".strip))
      self
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
    # Returns a reference to self
    #
    def where(clause)
      @query[:filter].merge!(clause.is_a?(String) ? Parser.new(clause).query : clause)
      self
    end

    # Parses the current query hash and returns a JSON string
    #
    def to_json
      @query.to_json
    end
  end
end