require File.dirname(__FILE__) + '/../../minitest_helper.rb'
require 'montage/client'
require 'faraday'

class Montage::Client::DocumentsTest < Montage::TestCase
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

  context "#documents" do
    setup do
      @response_status = 200
      @response_body = { "data" => [] }
      @payload = { filter: {}, limit: 1 }

      @stubs.post "/schemas/movies/query/", @payload.to_json do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Montage::Response.new(@response_status, @response_body, "document")
      response = @client.documents("movies", @payload)

      assert_response_equal expected, response
      assert_equal Montage::Documents, response.members.class
    end
  end

  context "#document" do
    setup do
      @response_status = 200
      @id = "fj3489qfh9853484yg54789y"
      @response_body = { "data" => [] }

      @stubs.get "/schemas/movies/#{@id}/" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Montage::Response.new(@response_status, @response_body, "document")
      response = @client.document("movies", @id)

      assert_response_equal expected, response
      assert_equal Montage::Documents, response.members.class
    end
  end

  context "#create_or_update_documents" do
    setup do
      @response_status = 200
      @response_body = { "data" => [] }
      @payload = [{}, {}]

      @stubs.post "/schemas/movies/save/", @payload.to_json do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Montage::Response.new(@response_status, @response_body, "document")
      response = @client.create_or_update_documents("movies", @payload)

      assert_response_equal expected, response
      assert_equal Montage::Documents, response.members.class
    end
  end

  context "#update_document" do
    setup do
      @response_status = 200
      @response_body = { "data" => [] }
      @payload = {}

      @stubs.post "/schemas/movies/save/", @payload.to_json do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Montage::Response.new(@response_status, @response_body, "document")
      response = @client.update_document("movies", @payload)

      assert_response_equal expected, response
      assert_equal Montage::Documents, response.members.class
    end
  end

  context "#delete_document" do
    setup do
      @response_status = 200
      @id = "fj85934hfw345hf985"
      @response_body = { "data" => [] }

      @stubs.delete "/schemas/movies/#{@id}/" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Montage::Response.new(@response_status, @response_body, "document")
      response = @client.delete_document("movies", @id)

      assert_response_equal expected, response
      assert_equal Montage::Documents, response.members.class
    end
  end
end
