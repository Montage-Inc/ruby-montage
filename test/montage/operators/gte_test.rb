require File.dirname(__FILE__) + '/../../minitest_helper.rb'
require 'montage/operators/gte'

class Montage::Operators::GteTest < Minitest::Test
  context ".==" do
    should "return true if the operator matches" do
      assert Montage::Operators::Gte == "foo >= 42"
    end

    should "return false if the operator does not match" do
      refute Montage::Operators::Gte == "foo > 42"
    end

    should "return false if the operator contains other operators" do
      refute Montage::Operators::Gte == "foo <>= 42"
    end
  end
end
