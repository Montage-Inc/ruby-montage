require File.dirname(__FILE__) + '/../../minitest_helper.rb'
require 'montage/operators/not'

class Montage::Operators::NotTest < Minitest::Test
  context ".==" do
    should "return true if the operator matches" do
      assert Montage::Operators::Not == "foo != 42"
    end

    should "return true if there are not spaces between the opearator and column names" do
      assert Montage::Operators::Not == "foo!=42"
    end

    should "return false if the operator does not match" do
      refute Montage::Operators::Not == "foo < 42"
    end

    should "return false if only the equal sign is passed in" do
      refute Montage::Operators::Not == "foo = 42"
    end
  end
end
