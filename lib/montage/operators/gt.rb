module Montage
  module Operators
    class Gt
      def self.operator
        ">"
      end

      def self.montage_operator
        "__gt"
      end

      def self.==(value)
        value =~ /[^=<]>[^=<]/
      end
    end
  end
end
