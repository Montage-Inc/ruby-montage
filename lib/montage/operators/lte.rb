require 'montage/operators'

module Montage
  module Operators
    class Lte < Collection
      def self.operator
        "<="
      end

      def self.montage_operator
        "__lte"
      end

      def self.==(value)

      end
    end
  end
end