require 'montage/errors'
require 'json'

module Montage
  class Parser

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
   			@query = parse_string_clause(clause)
   		end
  	end

  	def parse_query_value(queryparts, operator)
  		value = queryparts.split(' ')
      if is_i?(value)
        value[2].to_i
      elsif is_f?(value)
        value[2].to_f
      elsif operator == 'not in' || operator == 'in'
        value[2].gsub(/('|\(|\))/, "").split(',').map!{ |x| (is_i?(x) ? x.to_i : x) }
      elsif operator == '='
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

  	def parse_string_clause(clause)

  		OPERATOR_MAP.each do |key, value|
			  if clause.downcase.include? key
			  	@queryparts = clause.downcase.gsub(key, value)
			  	@operator = key
			  	@sqloperator = value
			  	break
			  end
			end

			raise QueryError, "Your query has an undetermined error" unless @queryparts
      raise QueryError, "The operator you have used is not a valid Montage query operator" unless @sqloperator

      value = parse_query_value(@queryparts,@operator)

      { "#{@queryparts.split(' ')[0]}#{@sqloperator}".to_sym => value }
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
