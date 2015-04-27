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
      self.classes.find(Proc.new { Montage::Collection }) { |c| c.collection_name == name }
    end
  end
end
