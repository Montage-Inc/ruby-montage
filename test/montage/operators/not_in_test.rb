require File.dirname(__FILE__) + '/../../minitest_helper.rb'
require 'montage/operators/not_in'

class Montage::Operators::NotInTest < Minitest::Test
  context ".==" do
    should "return true if the operator matches" do
      assert Montage::Operators::NotIn == "foo not in (1,2,3)"
    end

    should "return true if not in is capitalized" do
      assert Montage::Operators::NotIn == "foo NOT IN (1,2,3)"
    end

    should "return false if the operator does not match" do
      refute Montage::Operators::NotIn == "foo != 42"
    end

    should "return false if only the in operator is passed in" do
      refute Montage::Operators::NotIn == "foo in (1,2,3)"
    end
  end
end
