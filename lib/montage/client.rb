require 'montage/response'
require 'faraday'
require 'faraday_middleware'
require 'json'
require 'montage/client/files'
require 'montage/errors'

module Montage
  class Client

    attr_accessor :token, :username, :password, :domain, :api_version

    def initialize
      @api_version = 1
      yield(self) if block_given?
      if not @domain 
        raise MissingAttributeError, "You must declare the domain attribute"
      end
    end

    def content_type
      "application/json"
    end

    def auth
      build_response("token") do
        connection.post do |req|
          req.url "auth"
          req.basic_auth username, password
        end
      end
    end

    def get(url, resource_name, options = {})
      build_response(resource_name) do
        connection.get do |req|
          req.url url
          req.params = options
        end
      end
    end

    def post(url, resource_name, options = {})
      build_response(resource_name) do
        connection.post do |req|
          req.url url
          req.params = options.to_json
        end
      end
    end

    def put(url, resource_name, options = {})
      build_response(resource_name) do
        connection.put do |req|
          req.url url
          req.params = options.to_json
        end
      end
    end

    def delete(url, resource_name, options = {})
      build_response(resource_name) do
        connection.delete do |req|
          req.url url
          req.params = options.to_json
        end
      end
    end

    def build_response(resource_name, &block)
      response = yield
      Montage::Response.new(response.status, response.body, resource_name)
    end

    def connection
      @connect ||= Faraday.new do |f|
        f.adapter :net_http
        f.url_prefix = "https://#{domain}.montage.com/api/v#{api_version}/"
        f.headers["User-Agent"] = "Montage Ruby v#{Montage::VERSION}"
        f.headers["Content-Type"] = content_type
        f.headers["Accept"] = "*/*"
        f.basic_auth token, ""
        f.response :json, content_type: /\bjson$/
      end
    end
  end
end