module Montage
  module Operators
    class Equal
      def self.operator
        "="
      end

      def self.montage_operator
        ""
      end

      def self.==(value)
        value =~ /[^!<>]=[^!<>]/
      end
    end
  end
end
