require 'montage/operators/equal'
require 'montage/operators/not'
require 'montage/operators/not_in'
require 'montage/operators/lte'
require 'montage/operators/gte'
require 'montage/operators/lt'
require 'montage/operators/gt'
require 'montage/operators/ilike'
require 'montage/operators/like'
require 'montage/operators/in'
require 'montage/operators/nil'

module Montage
  module Operators
    def self.classes
      [
        Montage::Operators::Equal,
        Montage::Operators::Not,
        Montage::Operators::Lte,
        Montage::Operators::Gte,
        Montage::Operators::Lt,
        Montage::Operators::Gt,
        Montage::Operators::NotIn,
        Montage::Operators::In,
        Montage::Operators::Ilike,
        Montage::Operators::Like,
      ]
    end

    def self.find_operator(query_string)
      self.classes.find(Proc.new { Montage::Operators::Nil }) { |c| c == query_string }
    end
  end
end
