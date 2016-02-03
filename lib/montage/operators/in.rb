module Montage
  module Operators
    class In
      def self.operator
        "in"
      end

      def self.montage_operator
        "$in"
      end

      def self.==(value)
        value =~ /\bin\b(?=([^']*'[^']*')*[^']*$)/i && !value.downcase.include?("not")
      end
    end
  end
end
