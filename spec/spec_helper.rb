require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + '/../lib/render_caching.rb'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
