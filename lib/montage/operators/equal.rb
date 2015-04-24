require 'montage/operators'

module Montage
  module Operators
    class Equals < Collection
      def self.operator
        "="
      end

      def self.montage_operator
        ""
      end

      def self.==(value)

      end
    end
  end
end