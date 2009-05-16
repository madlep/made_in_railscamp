require 'rubygems'

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.expand_path("#{dir}/../lib"))

require 'spec'

Spec::Runner.configure do |config|
  config.mock_with :rr
end
