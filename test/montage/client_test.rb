require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/client'

class Montage::ClientTest < Minitest::Test
  context "initialization" do
    should "accept a username" do
      client = Montage::Client.new do |config|
        config.username = "me@foobar.com"
      end

      assert_equal "me@foobar.com", client.username
    end

    should "accept a password" do
      client = Montage::Client.new do |config|
        config.password = "foo"
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
      end

      assert_equal "aaaa", client.token
    end
  end
end
