require File.dirname(__FILE__) + '/../../minitest_helper.rb'
require 'montage/client'
require 'faraday'

class Montage::Client::FilesTest < Montage::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Montage::Client.new do |c|
      c.username = 'foo'
      c.password = 'bar'
      c.domain = 'foobar'
    end

    @client.stubs(:connection).returns(@connection)
  end

  context '#files' do
    setup do
      @response_status = 200
      @response_body = { 'data' => [] }
      @payload = { filter: {}, limit: 1 }
      @stubs.get 'files/' do
        [@response_status, {}, @response_body]
      end
    end

    should 'send the right request' do
      expected = Montage::Response.new(@response_status, @response_body, "file")
      response = @client.files

      assert_response_equal expected, response
      assert_equal Montage::Files, response.members.class
    end
  end

  context "#file" do
    setup do
      @response_status = 200
      @id = "fj3489qfh9853484yg54789y"
      @response_body = { "data" => [] }

      @stubs.get "/files/#{@id}/" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Montage::Response.new(@response_status, @response_body, "file")
      response = @client.file(@id)

      assert_response_equal expected, response
      assert_equal Montage::Files, response.members.class
    end
  end

  context "#upload file" do
    setup do
      @response_status = 200
      @response_body = { "data" => [] }
      @payload = [{}, {}]

      @stubs.post "/files/", @payload.to_json do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Montage::Response.new(@response_status, @response_body, "file")
      response = @client.new_file(@payload)

      assert_response_equal expected, response
      assert_equal Montage::Files, response.members.class
    end
  end

  context "#delete_file" do
    setup do
      @response_status = 200
      @id = "fj85934hfw345hf985"
      @response_body = { "data" => [] }

      @stubs.delete "/files/#{@id}/" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Montage::Response.new(@response_status, @response_body, "file")
      response = @client.destroy_file(@id)

      assert_response_equal expected, response
      assert_equal Montage::Files, response.members.class
    end
  end
end