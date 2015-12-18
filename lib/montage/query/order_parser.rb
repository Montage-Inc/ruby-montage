require 'montage/errors'

module Montage
  class OrderParser

    attr_reader :clause

    # Creates a properly formatted ReQON clause object
    #
    # * *Args* :
    #   - +clause+ -> A hash or string ordering value
    # * *Returns* :
    #   - A Montage::OrderParser instance
    # * *Raises* :
    #   - +ClauseFormatError+ -> If a blank string clause or a hash without
    #     a valid direction is found.
    #
    def initialize(clause)
      @clause = clause
      fail ClauseFormatError, "Message" unless clause_valid?
    end

    # Validates clause arguments
    #
    # * *Returns* :
    #   - A boolean
    #
    def clause_valid?
      if @clause.is_a?(Hash)
        @clause.flatten.find do |e|
          return true unless (/\basc\b|\bdesc\b/).match(e).nil?
        end
      else
        return true unless @clause.split.empty?
      end
    end

    # Parses a hash clause
    #
    # * *Returns* :
    #   - A ReQON formatted array
    # * *Examples* :
    #    @clause = { test: "asc"}
    #    @clause.parse
    #    ["$order_by", ["$asc", "test"]]
    #
    def parse_hash
      direction = clause.values.first
      field = clause.keys.first.to_s
      ["$order_by", ["$#{direction}", field]]
    end

    # Parses a string clause, defaults direction to asc if missing or invalid
    #
    # * *Returns* :
    #   - A ReQON formatted array
    # * *Examples* :
    #    @clause = "happy_trees desc"
    #    @clause.parse
    #    ["$order_by", ["$desc", "happy_trees"]]
    #
    def parse_string
      direction = clause.split[1]
      field = clause.split[0]
      direction = "asc" unless %w(asc desc).include?(direction)
      ["$order_by", ["$#{direction}", field]]
    end

    # Determines clause datatype and triggers the correct parsing
    #
    def parse
      @clause.is_a?(Hash) ? parse_hash : parse_string
    end
  end
end
