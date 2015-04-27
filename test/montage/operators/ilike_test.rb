require File.dirname(__FILE__) + '/../../minitest_helper.rb'
require 'montage/operators/ilike'

class Montage::Operators::IlikeTest < Minitest::Test
  context ".==" do
    should "return true if the operator matches" do
      assert Montage::Operators::Ilike == "foo ilike 'bar'"
    end

    should "return false if the operator does not match" do
      refute Montage::Operators::Ilike == "foo = 42"
    end

    should "not return true if the like operator is passed in" do
      refute Montage::Operators::Ilike == "foo like 'bar'"
    end

    should "return true if the operator is capitalized" do
      assert Montage::Operators::Ilike == "foo ILIKE 'bar'"
    end
  end
end
