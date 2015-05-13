require 'simplecov'

SimpleCov.start do
  if ENV['CI']=='true'
    require 'codecov'
    SimpleCov.formatter = SimpleCov::Formatter::Codecov
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
