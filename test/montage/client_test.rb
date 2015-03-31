require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/client'

class Montage::ClientTest < Minitest::Test
  context "initialization" do
    should "accept a username" do
      client = Montage::Client.new do |config|
        config.username = "me@foobar.com"
        config.domain= "test"
      end

      assert_equal "me@foobar.com", client.username
    end

    should "raise exception if no domain is passed" do
      assert_raises(Montage::MissingAttributeError, "You must declare the domain attribute") do
        client = Montage::Client.new do |config|
          config.username = "me@foobar.com"
        end
      end
    end

    should "set the api version to 1 by default" do
      client = Montage::Client.new do |config|
        config.username = "me@foobar.com"
        config.domain = "test"
      end
      assert_equal 1, client.api_version
    end
    should "overwrite the api version" do
      client = Montage::Client.new do |config|
        config.username = "me@foobar.com"
        config.domain = "test"
        config.api_version = 2
      end
      assert_equal 2, client.api_version
    end

    should "accept a password" do
      client = Montage::Client.new do |config|
        config.password = "foo"
        config.domain= "test"
      end

      assert_equal "foo", client.password
    end

    should "accept a domain name" do
      client = Montage::Client.new do |config|
        config.domain = "mydomain"
      end

      assert_equal "mydomain", client.domain
    end

    should "accept a token" do
      client = Montage::Client.new do |config|
        config.token = "aaaa"
        config.domain= "test"
      end

      assert_equal "aaaa", client.token
    end
  end

  context "on authorization" do
    setup do
      @client = Montage::Client.new do |c|
        c.username = "foo"
        c.password = "bar"
        c.domain = "foobar"
      end

      @success_body = {
        "data" => {
          "token" => "foonizzle"
        }
      }
    end

    should "set the token if the response was a success" do
      @client.build_response("token") do
        Faraday::Response.new(body: @success_body, status: 200)
      end

      assert_equal "foonizzle", @client.token
      assert_equal "Token foonizzle", @client.connection.headers["Authorization"]
    end

    should "skip setting the token if the response was not a success" do
      @client.build_response("token") do
        Faraday::Response.new(body: {}, status: 404)
      end

      assert_nil @client.token
    end
  end
end
