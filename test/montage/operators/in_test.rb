require 'minitest_helper'
require 'montage/operators/in'

class Montage::Operators::InTest < Minitest::Test
  context ".==" do
    should "return true if the operator matches" do
      assert Montage::Operators::In == "foo in (1,2,3)"
    end

    should "return false if the operator does not match" do
      refute Montage::Operators::In == "foo = 42"
    end

    should "return false if the not in operator is passed in" do
      refute Montage::Operators::In == "foo not in (1,2,3)"
    end

    should "return true if the operator is capitalized and matches" do
      assert Montage::Operators::In == "foo IN (1,2,3)"
    end

    should "ignore any operators that are inside single quotes" do
      refute Montage::Operators::In == "foo ilike 'kings'"
    end

    should "return false for an includes operator" do
      refute Montage::Operators::In == "foo includes '[\"foo\"]'"
    end
  end
end
