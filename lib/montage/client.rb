require 'montage/response'
require 'faraday'
require 'faraday_middleware'
require 'json'
require 'montage/client/files'
require 'montage/client/schemas'
require 'montage/client/documents'
require 'montage/errors'

module Montage
  class Client
    include Files
    include Schemas
    include Documents

    attr_accessor :token, :username, :password, :domain, :api_version

    def initialize
      @api_version = 1
      yield(self) if block_given?
      raise MissingAttributeError, "You must declare the domain attribute" unless @domain
    end

    def content_type
      "application/json"
    end

    def auth
      build_response("token") do
        connection.post do |req|
          req.headers.delete("Authorization")
          req.url "auth/"
          req.body = { username: username, password: password }.to_json
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
          req.body = options.to_json
        end
      end
    end

    def put(url, resource_name, options = {})
      build_response(resource_name) do
        connection.put do |req|
          req.url url
          req.body = options.to_json
        end
      end
    end

    def delete(url, resource_name, options = {})
      build_response(resource_name) do
        connection.delete do |req|
          req.url url
          req.body = options.to_json
        end
      end
    end

    def build_response(resource_name, &block)
      response = yield
      montage_response = Montage::Response.new(response.status, response.body, resource_name)

      if !response.success? 
        montage_response = Montage::Response.new(response.status, response.body, 'error')
      end

      if resource_name == "token" && response.success?
        @token = montage_response.token.value
        connection.headers["Authorization"] = "Token #{token}"
      end

      montage_response
    end

    def connection
      @connect ||= Faraday.new do |f|
        f.adapter :net_http
        f.url_prefix = "http://#{domain}.dev.montagehot.club/api/v#{api_version}/"
        f.headers["User-Agent"] = "Montage Ruby v#{Montage::VERSION}"
        f.headers["Content-Type"] = content_type
        f.headers["Accept"] = "*/*"
        f.headers["Authorization"] = "Token #{token}"
        f.response :json, content_type: /\bjson$/
      end
    end
  end
end