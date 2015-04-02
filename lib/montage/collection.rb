module Montage
  class Collection
    include Enumerable

    attr_reader :raw_items, :items

    def initialize(raw_items)
      @raw_items = raw_items.dup.freeze
      @items = parse_items
    end

    def self.collection_name
      "resources"
    end

    def self.resource_name
      "resource"
    end

    def item_class
      @item_class ||= Montage::Resources.find_class(self.class.resource_name)
    end

    def parse_items
      raw_items.map do |raw_item|
        if raw_item["_meta"]
          raw_item["created_at"] = raw_item["_meta"]["created"]
          raw_item["updated_at"] = raw_item["_meta"]["modified"]
        end

        item_class.new(raw_item)
      end
    end

    def singular?
      items.length < 2
    end

    def each(&block)
      items.each { |item| yield(item) }
    end
  end
end