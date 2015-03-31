require 'montage/resource'

module Montage
  class Schema < Resource
    def self.resource_name
      "schema"
    end

    def attribute_keys
      []
    end
  end
end