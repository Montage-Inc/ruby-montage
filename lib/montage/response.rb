require 'montage/collections'
require 'montage/resources'

module Montage
  class Response
    attr_reader :status, :body, :members, :resource_name, :raw_body

    def initialize(status, body, resource_name = "resource")
      @status = status
      @body = get_body(body)
      @raw_body = body.clone.freeze
      @resource_name = resource_name
      @members = parse_members
    end

    def get_body(body)
      if body.is_a?(Hash)
        body["data"] || body["errors"] || body || {}
      else
        body || []
      end
    end

    def success?
      if raw_body["errors"]
        return false
      else
        (200..299).include?(status)
      end
    end

    def respond_to?(method_name, include_private = false)
      resource_name.to_sym == method_name || "#{resource_name}s".to_sym == method_name || method_name == "errors".to_sym || super
    end

    def method_missing(method_name, *args, &block)
      return super unless resource_name.to_sym == method_name || "#{resource_name}s".to_sym == method_name || method_name == "errors".to_sym
      members
    end

  private

    def parse_members
      klass = if body.is_a?(Array)
        Montage::Collections.find_class("#{resource_name}s")
      else
        Montage::Resources.find_class(resource_name)
      end

      klass.new(body)
    end
  end
end
