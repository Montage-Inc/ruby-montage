require 'minitest_helper'
require 'montage/operators'

class Montage::OperatorsTest < Minitest::Test
  context ".find_class" do
    should "find the right class" do
      assert_equal Montage::Operators::Equal.operator, Montage::Operators.find_operator("foo == bar").operator
      assert_equal Montage::Operators::Not.operator, Montage::Operators.find_operator("foo != 'bar'").operator
      assert_equal Montage::Operators::Lte.operator, Montage::Operators.find_operator("foo <= 10").operator
      assert_equal Montage::Operators::NotIn.operator, Montage::Operators.find_operator("foo not in [1, 2, 3]").operator
      assert_equal Montage::Operators::Gte.operator, Montage::Operators.find_operator("foo >= 10").operator
      assert_equal Montage::Operators::Lt.operator, Montage::Operators.find_operator("foo < 10").operator
      assert_equal Montage::Operators::Gt.operator, Montage::Operators.find_operator("foo > 10").operator
      assert_equal Montage::Operators::Ilike.operator, Montage::Operators.find_operator("foo ilike bar").operator
      assert_equal Montage::Operators::Like.operator, Montage::Operators.find_operator("foo like bar").operator
      assert_equal Montage::Operators::Includes.operator, Montage::Operators.find_operator("foo includes bar").operator
      assert_equal Montage::Operators::Intersects.operator, Montage::Operators.find_operator("foo intersects bar").operator
      assert_nil Montage::Operators.find_operator("foo").operator
    end
  end
end
