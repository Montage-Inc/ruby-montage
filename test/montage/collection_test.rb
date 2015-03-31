require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/collection'

class Montage::CollectionTest < Minitest::Test
  should "return the proper resources" do
    raw_data = [
      {
        "foo" => "bar",
        "bar" => "foo"
      }
    ]

    collection = TestCollection.new(raw_data)
    collection.each { |item| assert item.is_a?(Montage::Schema) }
  end

  context "#singular?" do
    context "if there are no items" do
      setup do
        @collection = TestCollection.new([])
      end

      should "return true" do
        assert @collection.singular?
      end
    end

    context "if there is one item" do
      setup do
        @collection = TestCollection.new([{}])
      end

      should "return true" do
        assert @collection.singular?
      end
    end

    context "if there is more than one item" do
      setup do
        @collection = TestCollection.new([{}, {}])
      end

      should "return false" do
        assert !@collection.singular?
      end
    end
  end

  class TestCollection < Montage::Collection
    def self.collection_name
      "schemas"
    end

    def self.resource_name
      "schema"
    end
  end
end