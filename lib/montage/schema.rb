module Montage
  class Schema
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end