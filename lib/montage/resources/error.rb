require 'montage/resource'

module Montage
  class Error < Resource
    def self.resource_name
      "error"
    end

    def attribute_keys
      []
    end
  end
end