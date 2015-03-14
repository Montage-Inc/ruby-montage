require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/resources'

class Montage::ResourcesTest < Minitest::Test
  context ".find_class" do
    should "return the class name if it exists" do
      assert_equal Montage::Token, Montage::Resources.find_class("token")
    end

    should "return the base resource class if the name cannot be found" do
      assert_equal Montage::Resource, Montage::Resources.find_class("foo")
    end
  end
end