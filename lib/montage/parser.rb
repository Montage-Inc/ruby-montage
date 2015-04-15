require 'montage/errors'
require 'json'

module Montage
  class Parser
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

    def initialize(clause=nil)
      if(clause)
        @clause = clause
        @column_name = get_column_name
        @query_operator = get_operator
        @query_parts = get_query_parts
        @condition_set = parse_query_value

        @parse = parse_string_clause
      end
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

    def get_query_parts
      query_parts = false
      OPERATOR_MAP.each do |key, value|
        if @clause.downcase.include? key
          query_parts = @clause.downcase.gsub(key, value)
          break
        end
      end
      return false unless query_parts
      query_parts.split(' ')
    end

    def parse_query_value
      value = @query_parts
      if is_i?(value)
        value[2].to_i
      elsif is_f?(value)
        value[2].to_f
      elsif @query_operator[0] == 'not in' || @query_operator[0] == 'in'
        value[2].gsub(/('|\(|\))/, "").split(',').map!{ |x| (is_i?(x) ? x.to_i : x) }
      elsif @query_operator[0] == '='
        if is_i?(value[1]) 
          value[1].to_i
        else 
          value[1].gsub(/('|\(|\))/, "")
        end
      else
        if is_i?(value[2])
          value[2].to_i
        else 
          value[2].gsub(/('|\(|\))/, "")
        end
      end
    end

    def parse_value(value,operator)
      if is_i?(value)
        value.to_i
      elsif is_f?(value)
        value.to_f
      else
        if operator == 'in' || operator == 'not in'
          values = value.gsub(/('|\(|\))/, "").split(',').map!{ |x| (is_i?(x) ? x.to_i : x) }
        else
          value.gsub(/('|\(|\))/, "")
        end

      end
    end


    def parse_string_clause

      raise QueryError, "Your query has an undetermined error" unless @query_parts
      raise QueryError, "The operator you have used is not a valid Montage query operator" unless @query_operator[0]

      value = parse_query_value

      { "#{@query_parts[0]}#{@query_operator[1]}".to_sym => value }
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
  end
end
