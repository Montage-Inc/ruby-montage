module Montage
  class Resource
    attr_reader :attributes, :items

    def initialize(raw_data = {})
      @attributes = raw_data.dup.freeze
      @items = parse_items
    end

    def attribute_keys
      return items.keys.map(&:to_sym) if items.is_a?(Hash)
      []
    end

    def self.resource_name
      "resource"
    end

    def singular?
      true
    end

    def parse_items
      {}.tap do |hsh|
        attributes.each do |key, value|
          if key == "_meta"
            hsh["created_at"] = value["created"]
            hsh["updated_at"] = value["modified"]
          else
            hsh[key] = value
          end
        end
      end
    end

    def respond_to?(method_name, include_private = false)
      attribute_keys.include?(method_name) || super
    end

    def method_missing(method_name, *args, &block)
      attribute_keys.include?(method_name) ? items[method_name.to_s] : super
    end
  end
end
