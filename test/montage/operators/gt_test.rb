require 'minitest_helper'
require 'montage/operators/gt'

class Montage::Operators::GtTest < Minitest::Test
  context ".==" do
    should "return true if the operator matches" do
      assert Montage::Operators::Gt == "foo > 42"
    end

    should "return false if the operator doesn't match" do
      refute Montage::Operators::Gt == "foo = 42"
    end

    should "return false if the operator contains greater than and other operators" do
      refute Montage::Operators::Gt == "foo <> 42"
    end

    should "handle on_hand" do
      assert Montage::Operators::Gt == "on_hand > 42"
    end
  end
end
