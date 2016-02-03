module Montage
  module Operators
    class Like
      def self.operator
        "like"
      end

      def self.montage_operator
        "$contains"
      end

      def self.==(value)
        value =~ /like/i && !value.downcase.include?("ilike")
      end
    end
  end
end
