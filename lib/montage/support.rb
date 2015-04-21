module Montage
  module Support
    # Will take either an empty string or zero and turn it into a nil object
    # If the value passed in is neither zero or an empty string, will return the value
    #
    def nillify(value)
      return value unless ["", 0].include?(value)
      nil
    end

    # Determines if the string value passed in is an integer
    # Returns true or false
    #
    def is_i?(value)
      /\A\d+\z/ === value
    end

    # Determines if the string value passed in is a float
    # Returns true or false
    #
    def is_f?(value)
      /\A\d+\.\d+\z/ === value
    end
  end
end
