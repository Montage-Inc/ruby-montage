require 'montage/errors'
require 'montage/support'
require 'json'
require 'montage/operators'

module Montage
  class QueryParser
    include Montage::Support

    attr_reader :query

    TYPE_MAP = {
      is_i?: :to_i,
      is_f?: :to_f,
      is_s?: :to_s
    }

    # Creates a QueryParser instance based on a query argument.  The instance
    # can then be parsed into a ReQON compatible array and used as a filter
    # for queries
    #
    # * *Args* :
    #   - +query+ -> A hash or string that includes the database column name, a
    #     logical operator, and the associated value
    # * *Returns* :
    #   - A Montage::QueryParser instance
    #
    def initialize(query)
      @query = query
    end

    # Parse the column name from the specific query part
    #
    # * *Args* :
    #   - +part+ -> The query string
    #   - +splitter+ -> The value to split on
    # * *Returns* :
    #   - A string value for the provided column name
    # * *Examples* :
    #    @part = "bobross = 'amazing'"
    #    get_column_name(@part, " ")
    #    => "bobross"
    #
    def get_column_name(part, splitter = " ")
      part.downcase.split(splitter)[0].strip
    end

    # Grabs the proper query operator from the string
    #
    # * *Args* :
    #   - +part+ -> The query string
    # * *Returns* :
    #   - An array containing the supplied logical operator and the Montage
    #     equivalent
    # * *Examples* :
    #    @part = "tree_happiness_level > 9"
    #    get_query_operator(@part)
    #    => [">", "$gt"]
    #
    def get_query_operator(part)
      operator = Montage::Operators.find_operator(part)
      [operator.operator, operator.montage_operator]
    end

    # Extract the condition set from the given clause
    #
    # * *Args* :
    #   - +clause+ -> The query string
    #   - +splitter+ -> The logical operator to split on
    # * *Returns* :
    #   - The value portion of the query
    # * *Examples* :
    #    @part = "tree_happiness_level > 9"
    #    parse_condition_set(@part, "<")
    #    => "9"
    #
    def parse_condition_set(clause, splitter = " ")
      clause.split(/#{splitter}/i)[-1].strip
    end

    # Parse a single portion of the query string.  String values representing
    # a float or integer are coerced into actual numerical values.  Newline
    # characters are removed and single quotes are replaced with double quotes
    #
    # * *Args* :
    #   - +part+ -> The value element extracted from the query string
    # * *Returns* :
    #   - A parsed form of the value element
    # * *Examples* :
    #    @part = "9"
    #    parse_part(@part)
    #    => 9
    #
    def parse_part(part)
      parsed_part = JSON.parse(part) rescue part

      if is_i?(parsed_part)
        parsed_part.to_i
      elsif is_f?(parsed_part)
        parsed_part.to_f
      elsif parsed_part =~ /\(.*\)/
        to_array(parsed_part)
      elsif parsed_part.is_a?(Array)
        parsed_part
      else
        parsed_part.gsub(/('|')/, "")
      end
    end

    # Get all the parts of the query string
    #
    # * *Args* :
    #   - +str+ -> The query string
    # * *Returns* :
    #   - An array containing the column name, the montage operator, and the
    #     value for comparison.
    # * *Raises* :
    #   - +QueryError+ -> When incomplete queries or queries without valid
    #     operators are initialized
    # * *Examples* :
    #    @part = "tree_happiness_level > 9"
    #    get_parts(@part)
    #    => ["tree_happiness_level", "$gt", 9]
    #
    def get_parts(str)
      operator, montage_operator = get_query_operator(str)

      fail QueryError, "Invalid Montage query operator!" unless montage_operator

      column_name = get_column_name(str, operator)

      fail QueryError, "Your query has an undetermined error" unless column_name

      value = parse_part(parse_condition_set(str, operator))

      [column_name, montage_operator, value]
    end

    # Parse a hash type query
    #
    # * *Returns* :
    #   - A ReQON compatible array
    # * *Examples* :
    #    @test = Montage::QueryParser.new(tree_status: "happy")
    #    @test.parse_hash
    #    => [["tree_status", "happy"]]
    #
    def parse_hash
      query.map do |key, value|
        new_value = value.is_a?(Array) ? ["$in", value] : value
        [key.to_s, new_value]
      end
    end

    # Parse a string type query.  Splits multiple conditions on case insensitive
    # "and" strings that do not fall within single quotations. Note that the
    # Montage equals operator is supplied as a blank string
    #
    # * *Returns* :
    #   - A ReQON compatible array
    # * *Examples* :
    #    @test = Montage::QueryParser.new("tree_happiness_level > 9")
    #    @test.parse_string
    #    => [["tree_happiness_level", ["$__gt", 9]]]
    #
    def parse_string
      query.split(/\band\b(?=(?:[^']|'[^']*')*$)/i).map do |part|
        column_name, operator, value = get_parts(part)
        if operator == ""
          ["#{column_name}", value]
        else
          ["#{column_name}", ["#{operator}", value]]
        end
      end
    end

    # Determines query datatype and triggers the correct parsing
    #
    def parse
      if query.is_a?(Hash)
        parse_hash
      else
        parse_string
      end
    end

    # Takes a string value and splits it into an array
    # Will coerce all values into the type of the first type
    #
    # * *Args* :
    #   - +value+ -> A string value
    # * *Returns* :
    #   - A array form of the value argument
    # * *Examples* :
    #    @part = "(1, 2, 3)"
    #    to_array(@part)
    #    => [1, 2, 3]
    #
    def to_array(value)
      values = value.gsub(/('|\(|\))/, "").split(',')
      type = [:is_i?, :is_f?].find(Proc.new { :is_s? }) { |t| send(t, values.first) }
      values.map { |v| v.send(TYPE_MAP[type]) }
    end
  end
end
