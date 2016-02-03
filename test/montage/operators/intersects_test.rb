require 'minitest_helper'
require 'montage/operators/intersects'

class Montage::Operators::IncludesTest < Minitest::Test
  context ".==" do
    should "properly identify the operator" do
      assert Montage::Operators::Intersects == "foo intersects '[\"foo\"]'"
    end

    should "not return true if it is an IN operator" do
      refute Montage::Operators::Intersects == "foo in (1,2,3)"
    end
  end
end
