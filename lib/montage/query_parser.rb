require 'montage/errors'
require 'json'

module Montage
  class QueryParser
    attr_reader :clause

    OPERATOR_MAP = {
      " != "     => "__not",
      " >= "     => "__gte",
      " <= "     => "__lte",
      " = "      => "",
      " > "      => "__gt",
      " < "      => "__lt",
      " not in " => "__notin",
      " in "     => "__in",
      " like "   => "__contains",
      " ilike "  => "__icontains"
    }

    TYPE_MAP = {
      is_i?: :to_i,
      is_f?: :to_f,
      is_s?: :to_s
    }

    def initialize(clause)
      @clause = clause
    end

    def column_name
      @column_name ||= @clause.downcase.split(' ')[0]
    end

    def query_operator
      @query_operator ||= OPERATOR_MAP.find(Proc.new { [nil, nil] }) { |key, value| @clause.downcase.include?(key) }[1]
    end

    def condition_set
      @condition_set ||= @clause.split(/\s(?=(?:[^']|'[^']*')*$)/)[-1]
    end

    def parse_query_value
      if is_i?(condition_set)
        condition_set.to_i
      elsif is_f?(condition_set)
        condition_set.to_f
      elsif query_operator == '__notin' || query_operator == '__in'
        to_array(condition_set)
      else
        condition_set.gsub(/('|\(|\))/, "")
      end
    end

    # Parse the clause into a Montage query
    #
    def parse
      if @clause.is_a?(Hash)
        if clause.values.first.is_a?(Array)
          return {"#{clause.keys.first}__in".to_sym => @clause.values.first}
        else
          return @clause
        end
      end

      raise QueryError, "Your query has an undetermined error" unless column_name
      raise QueryError, "The operator you have used is not a valid Montage query operator" unless query_operator

      { "#{@column_name}#{query_operator}".to_sym => parse_query_value }
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
