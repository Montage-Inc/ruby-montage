require 'montage/collections/errors'
require 'montage/collections/files'
require 'montage/collections/schemas'
require 'montage/collections/documents'

module Montage
  module Collections
    def self.classes
      [
        Montage::Errors,
        Montage::Files,
        Montage::Schemas,
        Montage::Documents
      ]
    end

    def self.find_class(name)
      matches = self.classes.select { |c| c.collection_name == name }
      matches.first || Montage::Collection
    end
  end
end