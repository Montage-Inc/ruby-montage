require File.dirname(__FILE__) + '/../../minitest_helper.rb'
require 'montage/operators/equal'

class Montage::Operators::EqualTest < Minitest::Test
  context ".==" do
    should "return true if the string contains the equals operator" do
      assert Montage::Operators::Equal == "foo = bar"
    end

    should "return false if the string does not contain the equals operator" do
      refute Montage::Operators::Equal == "foo < bar"
    end

    should "return true if there are no spaces between the column name and operator" do
      assert Montage::Operators::Equal == "foo=bar"
    end

    should "return false if the string contains the not equal operator" do
      refute Montage::Operators::Equal == "foo != bar"
    end

    should "return false if the string contains the not equal operator with no spaces" do
      refute Montage::Operators::Equal == "foo!='bar'"
    end

    should "return false if the lt operator is present" do
      refute Montage::Operators::Equal == "foo <= 42"
    end

    should "return false if the gt operator is present" do
      refute Montage::Operators::Equal == "foo >= 42"
    end
  end
end
