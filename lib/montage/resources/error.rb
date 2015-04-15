require 'montage/resource'

module Montage
  class Error < Resource
    def self.resource_name
      "error"
    end
  end
end
