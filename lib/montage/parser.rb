require 'montage/errors'
require 'json'

module Montage
  class QueryParser
    attr_reader :parse, :query_operator, :column_name, :clause, :condition_set

    OPERATOR_MAP = {
      "!=" => "__not",
      ">=" => "__gte",
      "<=" => "__lte",
      "="  => "",
      ">"  => "__gt",
      "<"  => "__lt",
      "not in" => "__notin",
      "in" => "__in"
    }

    def initialize(clause)
      @clause = clause
      @column_name = get_column_name
      @query_operator = get_operator
      @condition_set = parse_query_value

      @parse = parse_string_clause
    end

    def get_column_name
      @clause.downcase.split(' ')[0]
    end

    def get_operator
      operator = OPERATOR_MAP.find { |key, value| @clause.downcase.include?(' ' + key + ' ') }
      if !operator 
        raise QueryError, "The operator you have used is not a valid Montage query operator"
      end
      operator
    end

    def get_query_value
      query_parts = false
      OPERATOR_MAP.each do |key, value|
        if @clause.downcase.include? key
          query_parts = @clause.downcase.gsub(key, value)
          break
        end
      end
      return false unless query_parts
      query_parts.split(' ')[-1]
    end

    def parse_query_value
      value = get_query_value
      if is_i?(value)
        value.to_i
      elsif is_f?(value)
        value.to_f
      elsif @query_operator[0] == 'not in' || @query_operator[0] == 'in'
        to_array(value)
      else
        value.gsub(/('|\(|\))/, "")
      end
    end

    def parse_string_clause

      raise QueryError, "Your query has an undetermined error" unless @column_name && @condition_set
      raise QueryError, "The operator you have used is not a valid Montage query operator" unless @query_operator[0]

      value = parse_query_value

      { "#{@column_name}#{@query_operator[1]}".to_sym => value }
    end

    def is_i?(value)
      /\A\d+\z/ === value
    end

    # Determines if the string value passed in is a float
    # Returns true or false
    #
    def is_f?(value)
      /\A\d+\.\d+\z/ === value
    end

    def to_array(value)
      type = ''
      value.gsub(/('|\(|\))/, "").split(',').each_with_index.map{ |x, index| 
        if index === 0
          if is_i?(x)
            type = 'int'
          elsif is_f?(x)
            type = 'float'
          end
        end

        if type == 'int'
          x.to_i
        elsif type == 'float'
          x.to_f
        else
          x
        end
      }
    end
  end
end
