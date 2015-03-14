module Montage
  class Resource
    attr_reader :attributes

    def initialize(raw_data = {})
      @attributes = raw_data.dup.freeze
    end

    def attribute_keys
      attributes.keys.map(&:to_sym)
    end

    def self.resource_name
      "resource"
    end

    def singular?
      true
    end

    def respond_to?(method_name, include_private = false)
      attribute_keys.include?(method_name) || super
    end

    def method_missing(method_name, *args, &block)
      attribute_keys.include?(method_name) ? attributes[method_name.to_s] : super
    end
  end
end