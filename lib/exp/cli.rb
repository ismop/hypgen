require 'faraday'
require 'json'

module Exp
  class Cli

    def initialize(options = {})
      @connection = options[:connection] || initialize_connection(options)
    end

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

    private

    attr_reader :connection

    def initialize_connection(options)
      url    = options[:url]
      verify = options[:verify]
      token  = options[:token]

      Faraday.new(url: url, ssl: {verify: verify}) do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
        faraday.headers['PRIVATE-TOKEN'] = token
        faraday.headers['Content-Type'] = 'application/json'
      end
    end
  end

  class AsCreationError < Exception
  end
end