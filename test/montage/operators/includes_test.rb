require 'minitest_helper'
require 'montage/operators/includes'

class Montage::Operators::IncludesTest < Minitest::Test
  context ".==" do
    should "properly identify the operator" do
      assert Montage::Operators::Includes == "foo includes '[\"foo\"]'"
    end

    should "not return true if it is an IN operator" do
      refute Montage::Operators::Includes == "foo in (1,2,3)"
    end
  end
end
