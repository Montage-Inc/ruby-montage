require 'montage/collection'

module Montage
  class Errors < Collection
    def self.collection_name
      "errors"
    end

    def self.resource_name
      "error"
    end
  end
end
