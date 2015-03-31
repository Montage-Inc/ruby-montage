require 'montage/collection'

module Montage
  class Documents < Collection
    def self.collection_name
      "documents"
    end

    def self.resource_name
      "document"
    end
  end
end