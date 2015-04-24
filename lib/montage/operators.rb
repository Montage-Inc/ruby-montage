require 'montage/operators/equals'
require 'montage/operators/__not'
require 'montage/operators/__lte'

module Montage
  module Operators
    def self.classes
      [
        Montage::Operators::Equals,
        Montage::Operators::Not,
        Montage::Operators::Lte,
      ]
    end

    def self.find_class(name)
      self.classes.find(Proc.new { Montage::Operator }) { |c| c.collection_name == name }
    end
  end
end
