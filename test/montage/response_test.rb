require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/response'

class Montage::ReponseTest < Minitest::Test
  context "initialization" do
    should "set the body to the passed in body if it is not a hash" do
      subject  = Montage::Response.new(200, { "data" => [ { "foo" => "bar" } ] }, "document")
      assert_equal([{ "foo" => "bar" }], subject.body)
    end

    should "create an errors collection response if there are errors" do
      subject  = Montage::Response.new(200, { "errors" => [ { "foo" => "bar" }, {"test"=> "fail"} ] }, "error")
      assert_equal Montage::Errors, subject.errors.class
    end
  end

  context "#success?" do
    should "be true if status is in the 200..299 range" do
      (200..299).each do |status|
        subject = Montage::Response.new(status, { "data" => [] })
        assert subject.success?
      end
    end

    should "be false if the body has errors" do
      (200..299).each do |status|
        subject = Montage::Response.new(status, { "errors" => [] }, "error")
        assert !subject.success?
      end
    end

    should "be false if the status code is 404" do
      subject = Montage::Response.new(404, { "errors" => [] }, "error")
      assert !subject.success?
    end

    should "be false if the status code is 415" do
      subject = Montage::Response.new(415, { "errors" => [] }, "error")
      assert !subject.success?
    end

    should "be false if the status code is 500" do
      subject = Montage::Response.new(500, { "errors" => [] }, "error")
      assert !subject.success?
    end

    should "not respond to" do
      subject = Montage::Response.new(404, { "errors" => [] }, "error")
      assert !subject.respond_to?('error')
    end
  end

  context "#get_body" do
    should "return the body's data element if it's not an error resource" do
      @subject = Montage::Response.new(200, { "data" => [{foo: "bar"}] }, "document")
      assert_equal([{foo: "bar"}], @subject.body)
    end

    should "return the body's error element if it is an error resource" do
      @subject = Montage::Response.new(200, { "errors" => [{foo: "bar"}] }, "error")
      assert_equal([{foo: "bar"}], @subject.body)
    end
  end

  context "#members" do
    setup do
      @body = {
        "data" => {
          "token" => "fdjsklajdflkj3iq09h598"
        }
      }
      @subject = Montage::Response.new(200, @body, "token")
    end

    should "parse the response properly and make the members available via a method call" do
      assert @subject.token.is_a?(Montage::Token)
      assert_equal "fdjsklajdflkj3iq09h598", @subject.token.value
    end

    should "not be successful" do
      body = {
        "errors" => {
          "blah" => "fdjsklajdflkj3iq09h598"
        }
      }
      subject = Montage::Response.new(200, body, "error")
      assert_equal Montage::Error, subject.errors.class
    end
  end
end
