module Montage
  class Token < Resource
    def self.resource_name
      "token"
    end

    def value
      token
    end
  end
end