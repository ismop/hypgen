require 'faraday'
require 'json'

module Exp
  class Cli
    include RestCli

    def start_as(requirements, options = {})
      puts "2. starting appliance set with following requirements: #{requirements}"

      response = connection.post do |req|
        req.url '/api/v1/appliance_sets'
        req.body = {
          appliance_set: {
            name: options[:name] || "HypGen appliance set #{Time.now}",
            priority: options[:priority] || 50,
            appliance_set_type: :workflow,
            appliances: requirements || []
          }
        }.to_json
      end

      raise(AsCreationError, response.body) unless response.status == 201

      JSON.parse(response.body)['appliance_set']['id']
    end
  end

  class AsCreationError < Exception
  end
end