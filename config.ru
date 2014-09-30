$: << './lib'

require 'rubygems'
require 'hypgen'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
  end
end

run Hypgen::Api::V1::Main
