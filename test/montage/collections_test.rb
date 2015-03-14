require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/collections'

class Montage::CollectionsTest < Minitest::Test
  should "find collections" do
    assert_equal Montage::Datum, Montage::Collections.find_class("datum")
    assert_equal Montage::Errors, Montage::Collections.find_class("errors")
    assert_equal Montage::Files, Montage::Collections.find_class("files")
  end

  should "return the base collection by default" do
    assert_equal Montage::Collection, Montage::Collections.find_class("foo")
  end
end