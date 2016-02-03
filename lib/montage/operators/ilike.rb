module Montage
  module Operators
    class Ilike
      def self.operator
        "ilike"
      end

      def self.montage_operator
        "$icontains"
      end

      def self.==(value)
        value =~ /\bilike\b/i
      end
    end
  end
end
