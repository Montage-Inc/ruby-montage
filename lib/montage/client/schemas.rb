module Montage
  class Client
    module Schemas
      # Public: Get a list of schemas
      #
      # Returns a Montage::Response
      def schemas
        get("schemas/", "schema")
      end

      # Public: Get a single schema
      #
      # Returns a Montage::Response
      def schema(name)
        get("schemas/#{name}/", "schema")
      end
    end
  end
end