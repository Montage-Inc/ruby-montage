module Montage
  module Operators
    class NotIn
      def self.operator
        "not in"
      end

      def self.montage_operator
        "$notin"
      end

      def self.==(value)
        value =~ /not in/i
      end
    end
  end
end
