require 'faraday'
require 'json'

module Dap
  class Cli
    include RestCli

    def create_exp(name, profile_ids, start_time, end_time)
      puts "1. creating new experiment for #{profile_ids} profiles with period #{start_time} - #{end_time}"

      response = connection.post do |req|
        req.url '/api/v1/experiments'
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          experiment: {
            name: name,
            start_date: start_time,
            end_date: end_time,
            profile_ids: profile_ids,
            status: :started
          }
        }.to_json
      end

      raise(ExpCreationError, response.body) unless response.status == 201

      JSON.parse(response.body)['experiment']['id']
    end

    def update_exp(exp_id, updated_fields)
      puts "Updating #{exp_id} experiment with following fields #{updated_fields}"

      response = connection.put do |req|
        req.url "/api/v1/experiments/#{exp_id}"
        req.headers['Content-Type'] = 'application/json'
        req.body = { experiment: updated_fields }.to_json
      end

      raise(ExpUpdateError, response.body) unless response.status == 200
    end
  end

  class ExpCreationError < Exception
  end

  class ExpUpdateError < Exception
  end
end