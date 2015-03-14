require 'montage/collection'

module Montage
  class Files < Collection
    def self.collection_name
      "files"
    end

    def self.resource_name
      "file"
    end
  end
end