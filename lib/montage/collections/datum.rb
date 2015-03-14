require 'montage/collection'

module Montage
  class Datum < Collection
    def self.collection_name
      "datum"
    end

    def self.resource_name
      "data"
    end
  end
end