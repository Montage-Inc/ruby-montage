require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/support'

class Montage::SupportTest < Minitest::Test
  class TestClass
    include Montage::Support
  end

  context "#nillify" do
    setup do
      @subject = TestClass.new
    end

    should "return the string if not empty" do
      assert_equal "foo", @subject.nillify("foo")
    end

    should "return nil if the string is empty" do
      assert_nil @subject.nillify("")
    end

    should "return the number if it is not zero" do
      assert_equal 9, @subject.nillify(9)
    end

    should "return nil if the number is zero" do
      assert_nil @subject.nillify(0)
    end
  end

  context "#is_i?" do
    setup do
      @subject = TestClass.new
    end

    should "return false if a float is passed in" do
      assert !@subject.is_i?("1.2")
    end

    should "return false if a string is passed in" do
      assert !@subject.is_i?("foo")
    end

    should "return true if an integer is passed in" do
      assert @subject.is_i?("1")
    end
  end

  context "#is_f?" do
    setup do
      @subject = TestClass.new
    end

    should "return false if an integer is passed in" do
      assert !@subject.is_f?("1")
    end

    should "return false if a string is passed in" do
      assert !@subject.is_f?("foo")
    end

    should "return true if a float is passed in" do
      assert @subject.is_f?("1.2")
    end
  end
end
