require 'montage/resources/token'
require 'montage/resources/error'
require 'montage/resources/file'
require 'montage/resources/schema'
require 'montage/resources/document'

module Montage
  module Resources
    def self.classes
      [
        Montage::Token,
        Montage::Error,
        Montage::File,
        Montage::Schema,
        Montage::Document
      ]
    end

    def self.find_class(name)
      matches = self.classes.select { |c| c.resource_name == name }

      matches.first || Montage::Resource
    end
  end
end
