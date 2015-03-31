require 'montage/collection'

module Montage
  class Schemas < Collection
    def self.collection_name
      "schemas"
    end

    def self.resource_name
      "schema"
    end
  end
end