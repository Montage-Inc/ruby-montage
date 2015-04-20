require 'json'
require 'montage/query_parser'

module Montage
  class Relation
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

    attr_reader :klass, :response, :query, :loaded

    alias_method :loaded?, :loaded

    def initialize(klass)
      @klass = klass
      @query = { filter: {} }
      @loaded = false
      @response = {}
    end

    # Support for WillPaginate, if it is defined. If not, returns self
    #
    def paginate(page: 1, per_page: 25)
      if Object.const_defined?("WillPaginate")
        WillPaginate::Collection.create(page, per_page, count) do |pager|
          pager.replace(self[pager.offset, pager.per_page]).to_a
        end
      else
        self
      end
    end

    # Defines the limit to apply to the query, defaults to nil
    #
    # Merges a hash:
    #  { limit: 10 }
    #
    # Returns a reference to self
    #
    def limit(max = nil)
      clone.tap { |r| r.query.merge!(limit: max) }
    end

    # Defines the offset to apply to the query, defaults to nil
    #
    # Merges a hash:
    #   { offset: 10 }
    #
    # Returns a reference to self
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

      clone.tap{ |r| r.query.merge!(order_by: field, ordering: direction) }
    end

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
      clone.tap { |r| r.query[:filter].merge!(clause.is_a?(String) ? Montage::QueryParser.new(clause).parse : clause) }
    end

    # Just adds a limit of 1 to the query, and forces to return a singular resource
    #
    def first
      limit(1).to_a.first
    end

    # Utility method to allow viewing of the result set in a console
    #
    def inspect
      to_a.inspect
    end

    # Returns the set of records if they have already been fetched, otherwise gets the records and returns them
    #
    def to_a
      return @records if loaded?

      @response = cache.get_or_set_query(klass, query) do
        connection.documents(klass.table_name, query: query)
      end

      @records = []

      if @response.success?
        @response.members.each do |member|
          @records << klass.new(member.attributes.merge(persisted: true))
        end

        @loaded = true
      end

      @records
    end

    # Force reload of the record
    #
    def reload
      reset
      to_a
      self
    end

    # Reset the whole shebang
    #
    def reset
      cache.remove("#{klass}/#{query}")
      @records = []
      @loaded = nil
      self
    end

    # Will take either an empty string or zero and turn it into a nil object
    # If the value passed in is neither zero or an empty string, will return the value
    #
    def nillify(value)
      return value unless ["", 0].include?(value)
      nil
    end

    # Parses the current query hash and returns a JSON string
    #
    def to_json
      @query.to_json
    end
  end
end
