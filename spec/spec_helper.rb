require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'hypgen'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end