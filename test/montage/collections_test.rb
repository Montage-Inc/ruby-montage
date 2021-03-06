require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/collections'

class Montage::CollectionsTest < Minitest::Test
  should "find collections" do
    assert_equal Montage::Schemas, Montage::Collections.find_class("schemas")
    assert_equal Montage::Errors, Montage::Collections.find_class("errors")
    assert_equal Montage::Files, Montage::Collections.find_class("files")
    assert_equal Montage::Documents, Montage::Collections.find_class("documents")
  end

  should "return the base collection by default" do
    assert_equal Montage::Collection, Montage::Collections.find_class("foo")
  end
end