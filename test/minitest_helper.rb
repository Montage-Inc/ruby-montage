require 'simplecov'

# To run tests with coverage:
# COVERAGE=true rake test

if ENV['COVERAGE']
  SimpleCov.start do
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'montage'

require 'minitest/autorun'
require 'minitest/reporters'
require 'shoulda-context'
require 'mocha/setup'
require 'faraday'


Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(:color => true)]

class Montage::TestCase < Minitest::Test
  def assert_response_equal(expected, response)
    assert_equal expected.status, response.status
    assert_equal expected.resource_name, response.resource_name
    assert_equal expected.body, response.body
    assert_equal expected.raw_body, response.raw_body
  end
end
