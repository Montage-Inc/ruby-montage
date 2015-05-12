require File.dirname(__FILE__) + '/../../minitest_helper.rb'
require 'montage/client'
require 'faraday'

class Montage::Client::SchemasTest < Montage::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Montage::Client.new do |c|
      c.username = "foo"
      c.password = "bar"
      c.domain = "foobar"
    end

    @client.stubs(:connection).returns(@connection)
  end

  context "#schemas" do
    setup do
      @response_status = 200
      @response_body = { "data" => [] }

      @stubs.get "/schemas/" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Montage::Response.new(@response_status, @response_body, "schema")
      response = @client.schemas

      assert_response_equal expected, response
      assert_equal Montage::Schemas, response.members.class
    end
  end

  context "#schema" do
    setup do
      @response_status = 200
      @response_body = { "data" => [] }
      @schema = "movies"

      @stubs.get "/schemas/#{@schema}/" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Montage::Response.new(@response_status, @response_body, "schema")
      response = @client.schema("movies")

      assert_response_equal expected, response
      assert_equal Montage::Schemas, response.members.class
    end
  end
end
