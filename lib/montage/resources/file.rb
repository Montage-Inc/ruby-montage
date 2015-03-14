require 'montage/resource'

module Montage  
  class File < Resource
    def self.resource_name
      "file"
    end

    def attribute_keys
      %i{file_name}
    end
  end
end