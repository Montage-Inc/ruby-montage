require 'montage/resource'

module Montage
  class Error < Resource
    def self.resource_name
      "error"
    end
    
    def each
		  if attributes.is_a?(Array)
		    attributes.each { |attribute| yield attribute }
		  elsif attributes.is_a?(Hash)
		    attributes.each { |key, value| yield key, value }
		  end
  	end

  end
end