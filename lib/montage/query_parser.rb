require 'montage/errors'
require 'montage/support'
require 'json'
require 'montage/operators'

module Montage
  class QueryParser
    include Montage::Support

    attr_reader :query

    OPERATOR_MAP = {
      "!="     => "__not",
      ">="     => "__gte",
      "<="     => "__lte",
      "="      => "",
      ">"      => "__gt",
      "<"      => "__lt",
      "not in" => "__notin",
      "in"     => "__in",
      "ilike"  => "__icontains",
      "like"   => "__contains"
    }

    TYPE_MAP = {
      is_i?: :to_i,
      is_f?: :to_f,
      is_s?: :to_s
    }

    def initialize(query)
      @query = query
    end

    # Parse the column name from the specific query part
    #
    def get_column_name(part, splitter = " ")
      part.downcase.split(splitter)[0].strip
    end

    # Grabs the proper query operator from the string
    #
    def get_query_operator(part)
      puts Montage::Operators.find_class(part)
      OPERATOR_MAP.find(Proc.new { [nil, nil] }) { |key, value| part.include?(key) }
    end

    # Extract the condition set from the given clause
    #
    def parse_condition_set(clause, splitter = " ")
      clause.split(splitter)[-1].strip
    end

    # Parse a single portion of the query string
    #
    def parse_part(part)
      if is_i?(part)
        part.to_i
      elsif is_f?(part)
        part.to_f
      elsif part =~ /\(.*\)/
        to_array(part)
      else
        part.gsub(/('|')/, "")
      end
    end

    # Get all the parts of the query string
    #
    def get_parts(str)
      operator, montage_operator = get_query_operator(str)

      raise QueryError, "The operator you have used is not a valid Montage query operator" unless montage_operator

      column_name = get_column_name(str, operator)

      raise QueryError, "Your query has an undetermined error" unless column_name

      value = parse_part(parse_condition_set(str, operator))

      [column_name, montage_operator, value]
    end

    # Parse a hash type query
    #
    def parse_hash(hsh)
      Hash[
        hsh.map do |key, value|
          new_key = value.is_a?(Array) ? "#{key}__in".to_sym : key
          [new_key, value]
        end
      ]
    end

    # Parse a string type query
    #
    def parse_string(str)
      Hash[
        str.downcase.split("and").map do |part|
          column_name, operator, value = get_parts(part)
          ["#{column_name}#{operator}".to_sym, value]
        end
      ]
    end

    # Parse the clause into a Montage query
    #
    def parse
      if query.is_a?(Hash)
        parse_hash(query)
      else
        parse_string(query)
      end
    end

    # Takes a string value and splits it into an array
    # Will coerce all values into the type of the first type
    #

    def to_array(value)
      values = value.gsub(/('|\(|\))/, "").split(',')
      type = %i(is_i? is_f?).find(Proc.new { :is_s? }) { |t| send(t, values.first) }
      values.map { |v| v.send(TYPE_MAP[type]) }
    end
  end
end
