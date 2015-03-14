require 'montage/resource'

module Montage
  class Data < Resource
    def self.resource_name
      "data"
    end

    def attribute_keys
      []
    end
  end
end