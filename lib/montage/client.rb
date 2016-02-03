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

    attr_accessor :token,
                  :username,
                  :password,
                  :domain,
                  :api_version,
                  :environment,
                  :test_url

    # Initializes the client instance
    #
    # * *Attributes* :
    #   - +token+ -> API access token required for requests, does not expire
    #   - +username+ -> Montage username credential
    #   - +password+ -> Montage password credential
    #   - +domain+ -> Project subdomain, required for initialization
    #   - +api_version+ -> API version to query against, defaults to 1
    #   - +environment+ -> Specifies desired environment for requests, defaults
    #     to 'production'. Valid options are 'development', 'production', and 'test'.
    #   - +test_url+ -> Test URL. Required when environment is set to 'test'.
    # * *Returns* :
    #   - A valid Montage::Client instance
    # * *Raises* :
    #   - +MissingAttributeError+ -> If the domain attribute is not specified
    #   - +InvalidEnvironment+ -> If the environment attribute is not set to 'production' or 'development'
    #   - +MissingAttributeError+ -> If the test_url is not provided when environment is 'test'
    #
    def initialize
      @api_version = 1
      @environment ||= "production"
      yield(self) if block_given?
      fail MissingAttributeError, "You must declare the domain attribute" unless @domain
      fail InvalidEnvironment, "Valid options are 'production' and 'development'" unless environment_valid?
      fail MissingAttributeError, "You must include a test_url for the 'test' environment" unless test_environment_valid?
    end

    # Verifies the Montage::Client instance environment
    #
    # * *Returns* :
    #   - A boolean
    #
    def environment_valid?
      %w(test production development).include?(@environment)
    end

    # Verifies that the test_url is supplied when the environment is set to test
    #
    # * *Returns* :
    #   - A boolean
    #
    def test_environment_valid?
      return true unless @environment == "test"
      !!@test_url
    end

    # Generates a base url for requests using the supplied environment and domain
    #
    # * *Returns* :
    #   - A string containing the constructed url
    #
    def default_url_prefix
      case @environment
      when "development" then "https://#{domain}.dev.montagehot.club"
      when "production" then "https://#{domain}.mntge.com"
      when "test" then @test_url
      end
    end

    # Attempts to authenticate with the Montage API
    #
    # * *Returns* :
    #   - A hash containing a valid token or an error string, oh no!
    #
    def auth
      build_response("token") do
        connection.post do |req|
          req.headers.delete("Authorization")
          req.url "auth/"
          req.body = { username: username, password: password }.to_json
        end
      end
    end

    # Requests resources from the Montage API, TODO:ADD EXAMPLES
    #
    # * *Args*    :
    #   - +url+ -> The url of the targeted resource
    #   - +resource_name+ -> The name of the targeted resource
    #   - +options+ -> A hash of desired options
    # * *Returns* :
    #   * A Montage::Response Object containing:
    #     - A http status code
    #     - The response body
    #     - The resource name
    #
    def get(url, resource_name, options = {})
      build_response(resource_name) do
        connection.get do |req|
          req.url url
          req.params = options
        end
      end
    end

    # Posts to the Montage API with a JSON options string, TODO:ADD EXAMPLES
    #
    # * *Args*    :
    #   - +url+ -> The url of the targeted resource
    #   - +resource_name+ -> The name of the targeted resource
    #   - +options+ -> A hash of desired options
    # * *Returns* :
    #   * A Montage::Response Object containing:
    #     - A http status code
    #     - The response body
    #     - The resource name
    #
    def post(url, resource_name, options = {})
      build_response(resource_name) do
        connection.post do |req|
          req.url url
          req.body = options.to_json
        end
      end
    end

    # Updates an existing Montage resource with a JSON options string, TODO:ADD EXAMPLES
    #
    # * *Args*    :
    #   - +url+ -> The url of the targeted resource
    #   - +resource_name+ -> The name of the targeted resource
    #   - +options+ -> A hash of desired options
    # * *Returns* :
    #   * A Montage::Response Object containing:
    #     - A http status code
    #     - The response body
    #     - The resource name
    #
    def put(url, resource_name, options = {})
      build_response(resource_name) do
        connection.put do |req|
          req.url url
          req.body = options.to_json
        end
      end
    end

    # Removes an existing Montage resource with a JSON options string, TODO:ADD EXAMPLES
    #
    # * *Args*    :
    #   - +url+ -> The url of the targeted resource
    #   - +resource_name+ -> The name of the targeted resource
    #   - +options+ -> A hash of desired options
    # * *Returns* :
    #   * A Montage::Response Object containing:
    #     - A http status code
    #     - The response body
    #     - The resource name
    #
    def delete(url, resource_name, options = {})
      build_response(resource_name) do
        connection.delete do |req|
          req.url url
          req.body = options.to_json
        end
      end
    end

    # Sets the authentication token on the client instance and http headers
    #
    # * *Returns* :
    #   - A string with the proper token interpolated
    #
    def set_token(token)
      @token = token
      connection.headers["Authorization"] = "Token #{token}"
    end

    # Checks the response body for an errors key and a successful http status code
    #
    # * *Args*    :
    #   - +response+ -> The Montage API response
    # * *Returns* :
    #   - A boolean
    #
    def response_successful?(response)
      return false if response.body["errors"]
      response.success?
    end

    # Instantiates a response object based on the yielded block
    #
    # * *Args*    :
    #   - +resource_name+ -> The name of the Montage resource
    # * *Returns* :
    #   * A Montage::Response Object containing:
    #     - A http status code
    #     - The response body
    #     - The resource name
    #
    def build_response(resource_name)
      response = yield
      resource = response_successful?(response) ? resource_name : "error"

      response_object = Montage::Response.new(response.status, response.body, resource)

      set_token(response_object.token.value) if resource_name == "token" && response.success?

      response_object
    end

    # Supplies the Faraday connection with proper headers
    #
    # * *Returns* :
    #   - A hash of instance specific headers for requests
    #
    def connection_headers
      {
        "User-Agent" => "Montage Ruby v#{Montage::VERSION}",
        "Content-Type" => "application/json",
        "Accept" => "*/*",
        "Authorization" => "Token #{token}",
        "Referer" => "#{default_url_prefix}/"
      }
    end

    # Creates an Faraday connection instance for requests
    #
    # * *Returns* :
    #   - A Faraday connection object with an instance specific configuration
    #
    def connection
      @connect ||= Faraday.new do |f|
        f.adapter :net_http
        f.headers = connection_headers
        f.url_prefix = "#{default_url_prefix}/api/v#{api_version}/"
        f.response :json, content_type: /\bjson$/
      end
    end
  end
end
