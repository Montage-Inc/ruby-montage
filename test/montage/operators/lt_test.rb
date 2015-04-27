require File.dirname(__FILE__) + '/../../minitest_helper.rb'
require 'montage/operators/lt'

class Montage::Operators::LtTest < Minitest::Test
  context ".==" do
    should "return true if the operator matches" do
      assert Montage::Operators::Lt == "foo < 42"
    end

    should "return true if there is no space between the columns and operator" do
      assert Montage::Operators::Lt == "foo<42"
    end

    should "return false if the operator doesn't match" do
      refute Montage::Operators::Lt == "foo = 42"
    end

    should "return false if the operator contains an equal" do
      refute Montage::Operators::Lt == "foo <= 42"
    end

    should "return false the operator contains another operator" do
      refute Montage::Operators::Lt == "foo <> 42"
    end
  end
end
