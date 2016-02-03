module Montage
  module Operators
    class Includes
      def self.operator
        "includes"
      end

      def self.montage_operator
        "$includes"
      end

      def self.==(value)
        value =~ /\bincludes\b(?=([^']*'[^']*')*[^']*$)/i
      end
    end
  end
end
