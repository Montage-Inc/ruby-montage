require File.dirname(__FILE__) + '/../../minitest_helper.rb'
require 'montage/operators/lte'

class Montage::Operators::LteTest < Minitest::Test
  context ".==" do
    should "return true if the operator matches" do
      assert Montage::Operators::Lte == "foo <= 42"
    end

    should "return true if there are no spaces between the matching operator" do
      assert Montage::Operators::Lte == "foo<=42"
    end

    should "return false if the operator doesn't match" do
      refute Montage::Operators::Lte == "foo = 42"
    end

    should "return false if the operator does not contain an equal sign" do
      refute Montage::Operators::Lte == "foo < 42"
    end

    should "return false if the string contains other operators" do
      refute Montage::Operators::Lte == "foo <=> 42"
    end
  end
end
