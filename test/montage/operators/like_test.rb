require 'minitest_helper'
require 'montage/operators/like'

class Montage::Operators::LikeTest < Minitest::Test
  context ".==" do
    should "return true if the operator matches" do
      assert Montage::Operators::Like == "foo like 'bar'"
    end

    should "return false if the operator does not match" do
      refute Montage::Operators::Like == "foo = 42"
    end

    should "not return true if the ilike operator is passed in" do
      refute Montage::Operators::Like == "foo ilike 'bar'"
    end

    should "return true if the operator is capitalized" do
      assert Montage::Operators::Like == "foo LIKE 'bar'"
    end
  end
end
