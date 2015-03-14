require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/resource'

class Montage::ResourceTest < Minitest::Test
  class TestResource < Montage::Resource

  end

  should "respond to all attribute keys" do
    resource = TestResource.new({"id" => "1234", "name" => "gary"})
    assert resource.respond_to?(:id)
    assert resource.respond_to?(:name)
  end

  should "process the raw data properly" do
    resource = TestResource.new("id" => "1234")
    assert_equal "1234", resource.id
  end

  should "default unset attributes to nil" do
    resource = TestResource.new("id" => "1234", "name" => nil)
    assert_nil resource.name
  end
end