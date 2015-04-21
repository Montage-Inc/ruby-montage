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

  should "return empty attribute keys" do 
    resource = TestResource.new
    assert_equal [], resource.attribute_keys
  end

  should "return resource name" do
    assert Montage::Resource.resource_name
  end

  should "should be singular" do
    resource = TestResource.new
    assert_equal true, resource.singular?
  end

  should "process the raw data properly" do
    resource = TestResource.new("id" => "1234")
    assert_equal "1234", resource.id
  end

  should "default unset attributes to nil" do
    resource = TestResource.new("id" => "1234", "name" => nil)
    assert_nil resource.name
  end

  should "respond to all the attributes" do
    @time = Time.now
    attributes = {
      "id" => "1234",
      "name" => "foo",
      "_meta" => {
        "created" => @time,
        "modified" => @time
      }
    }
    resource = TestResource.new(attributes)

    assert_equal "1234", resource.id
    assert_equal "foo", resource.name
    assert_equal @time, resource.created_at
    assert_equal @time, resource.updated_at
  end

  context "#parse_items" do
    should "properly parse the attributes" do
      @time = Time.now
      attributes = {
        "id" => "1234",
        "name" => "foo",
        "_meta" => {
          "created" => @time,
          "modified" => @time
        }
      }
      resource = TestResource.new(attributes)

      assert_equal "1234", resource.items["id"]
      assert_equal "foo", resource.items["name"]
      assert_equal @time, resource.items["created_at"]
      assert_equal @time, resource.items["updated_at"]
    end
  end
end
