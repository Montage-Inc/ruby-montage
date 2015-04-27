require 'montage/operators/equals'
require 'montage/operators/not'
require 'montage/operators/notin'
require 'montage/operators/lte'
require 'montage/operators/gte'
require 'montage/operators/lt'
require 'montage/operators/gt'
require 'montage/operators/ilike'
require 'montage/operators/like'
require 'montage/operators/in'

module Montage
  module Operators
    def self.classes
      [
        Montage::Operators::Equals,
        Montage::Operators::Not,
        Montage::Operators::Lte,
        Montage::Operators::Gte,
        Montage::Operators::Lt,
        Montage::Operators::Gt,
        Montage::Operators::Notin,
        Montage::Operators::In,
        Montage::Operators::Ilike,
        Montage::Operators::Like,
      ]
    end

    def self.find_class(name)
      self.classes.find(Proc.new { Montage::Operator }) { |o| o.operator == name }
    end
  end
end
