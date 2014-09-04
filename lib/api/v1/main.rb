require 'grape'

module Hypgen
  module Api
    module V1
      class Main < Grape::API
        version 'v1', using: :header, vendor: :dice
        format :json

        mount Hypgen::Api::V1::Experiment => '/api'
      end
    end
  end
end