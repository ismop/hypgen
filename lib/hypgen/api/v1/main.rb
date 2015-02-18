require 'grape'

module Hypgen
  module Api
    module V1
      class Main < Grape::API
        version 'v1', using: :header, vendor: :dice
        format :json

        before do
          unless env['REQUEST_METHOD'] == 'OPTIONS'
            auth = Rack::Auth::Basic::Request.new(env)
            valid = Hypgen.config.username == auth.username &&
                      Hypgen.config.password == auth.credentials.last

            throw(:error, status: 401, message: 'API Authorization Failed.') unless valid
          end
        end

        mount Hypgen::Api::V1::ThreatAssessments => '/api'
      end
    end
  end
end