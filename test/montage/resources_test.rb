require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/resources'

class Montage::ResourcesTest < Minitest::Test
  context ".find_class" do
    should "return the class name if it exists" do
      assert_equal Montage::Token, Montage::Resources.find_class("token")
      assert_equal Montage::Document, Montage::Resources.find_class("document")
      assert_equal Montage::Schema, Montage::Resources.find_class("schema")
    end

    should "return the base resource class if the name cannot be found" do
      assert_equal Montage::Resource, Montage::Resources.find_class("foo")
    end
  end
end