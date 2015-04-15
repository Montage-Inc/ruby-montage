$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'montage'

require 'minitest/autorun'
require 'minitest/reporters'
require 'shoulda-context'
require 'mocha/setup'
require 'faraday'

Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(:color => true)]
