require 'montage/errors'
require 'json'

module Montage
  class Parser

  	OPERATOR_MAP = {
      "=" => "",
      "!=" => "__not",
      ">" => "__gt",
      ">=" => "__gte",
      "<" => "__lt",
      "<=" => "__lte",
      "in" => "__in"
    }

  	def initialize(clause=nil)
  		if(clause)
   			@query = parse_string_clause(clause)
   		end
  	end

  	def parse_value(value)
      if is_i?(value)
        value.to_i
      elsif is_f?(value)
        value.to_f
      else
        value.gsub(/('|\(|\))/, "")
      end
    end

  	def parse_string_clause(clause)
      split = clause.split(" ")
      raise QueryError, "Your query has an undetermined error" unless split.count == 3

      operator = OPERATOR_MAP[split[1].downcase]
      raise QueryError, "The operator you have used is not a valid Montage query operator" unless operator

      value = parse_value(split[2])

      { "#{split[0]}#{operator}".to_sym => value }
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
    attr_reader :query
  end
end
