require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/client'

class Montage::ClientTest < Minitest::Test
  context "initialization" do
    should "accept a username" do
      client = Montage::Client.new do |c|
        c.username = "me@foobar.com"
        c.domain = "test"
      end

      assert_equal "me@foobar.com", client.username
    end

    should "raise exception if no domain is passed" do
      assert_raises(Montage::MissingAttributeError, "You must declare the domain attribute") do
        Montage::Client.new do |c|
          c.username = "me@foobar.com"
        end
      end
    end

    should "set the api version to 1 by default" do
      client = Montage::Client.new do |c|
        c.username = "me@foobar.com"
        c.domain = "test"
      end
      assert_equal 1, client.api_version
    end

    should "overwrite the api version" do
      client = Montage::Client.new do |c|
        c.username = "me@foobar.com"
        c.domain = "test"
        c.api_version = 2
      end

      assert_equal 2, client.api_version
    end

    should "accept a password" do
      client = Montage::Client.new do |c|
        c.password = "foo"
        c.domain = "test"
      end

      assert_equal "foo", client.password
    end

    should "accept a domain name" do
      client = Montage::Client.new do |c|
        c.domain = "mydomain"
      end

      assert_equal "mydomain", client.domain
    end

    should "accept a token" do
      client = Montage::Client.new do |c|
        c.token = "aaaa"
        c.domain = "test"
      end

      assert_equal "aaaa", client.token
    end

    should "accept an environment parameter" do
      client = Montage::Client.new do |c|
        c.environment = "production"
        c.domain = "test"
      end

      assert_equal "production", client.environment
    end

    should "default the environment param to production" do
      client = Montage::Client.new do |c|
        c.domain = "test"
      end

      assert_equal "production", client.environment
    end

    should "raise an exception if an invalid environment is specified" do
      assert_raises(Montage::InvalidEnvironment) do
        Montage::Client.new do |c|
          c.domain = "test"
          c.environment = "foo"
        end
      end
    end
  end

  context "#default_url_prefix" do
    should "return the production url when configured for a production environment" do
      client = Montage::Client.new do |c|
        c.domain = "test"
        c.environment = "production"
      end

      assert_equal "https://test.mntge.com", client.default_url_prefix
    end

    should "return the development url when configured for a development environment" do
      client = Montage::Client.new do |c|
        c.domain = "test"
        c.environment = "development"
      end

      assert_equal "https://test.dev.montagehot.club", client.default_url_prefix
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
      @client.expects(:set_token).with("foonizzle")

      @client.build_response("token") do
        Faraday::Response.new(body: @success_body, status: 200)
      end
    end

    should "skip setting the token if the response was not a success" do
      @client.expects(:set_token).never

      @client.build_response("token") do
        Faraday::Response.new(body: { "errors" => [] }, status: 404)
      end

      assert_nil @client.token
    end
  end

  context "#set_token" do
    setup do
      @client = Montage::Client.new do |c|
        c.username = "foo"
        c.password = "bar"
        c.domain = "foobar"
      end
    end

    should "set the token and update the headers" do
      @client.set_token("foonizzle")

      assert_equal "foonizzle", @client.token
      assert_equal "Token foonizzle", @client.connection.headers["Authorization"]
    end
  end

  context "#build_response" do
    setup do
      @client = Montage::Client.new do |c|
        c.username = "foo"
        c.password = "bar"
        c.domain = "foobar"
      end
    end

    context "when the server returns a 500" do
      setup do
        @response = Faraday::Response.new
        @response.stubs(:body).returns("errors" => [])
        @response.stubs(:status).returns(500)
      end

      should "create an error resource in the response object" do
        resp = @client.build_response("documents") do
          @response
        end

        assert resp.members.is_a?(Montage::Errors)
      end
    end

    context "when the server returns a 200 with errors" do
      setup do
        @response = Faraday::Response.new
        @response.stubs(:body).returns(
          "errors" => [
            {
              "document" =>
                { "id" => "0838d9f9-5cd9-40dd-94e9-5f780cd97df7",
                  "title" => "The Son of Jaws Returns II: Jaws Harder",
                  "rank" => 0,
                  "rating" => 0,
                  "votes" => 0,
                  "_meta" => { "created" => "2015-04-18T19:21:44.989Z", "modified" => "2015-04-18T19:21:44.989Z" },
                  "year" => "foo"
                },
              "errors" => { "year" => ["Enter a number."] }
            }
          ]
        )
        @response.stubs(:status).returns(200)
      end

      should "create an error resource in the response object" do
        resp = @client.build_response("documents") do
          @response
        end

        assert resp.members.is_a?(Montage::Errors)
      end
    end
  end
end
