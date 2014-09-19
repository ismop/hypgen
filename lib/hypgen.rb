# use resolv-replace for DNS lookups
require 'resolv-replace'

module Hypgen
  extend self

  def config
    @config ||= Config.new(ARGV[0] || 'config.yml')
  end

  def exp
    @exp_cli ||= Exp::Cli.new(
        url:    Hypgen.config.exp_url,
        verify: Hypgen.config.exp_verify,
        token:  Hypgen.config.exp_token
      )
  end

  def dap
    @dap_cli ||= Dap::Cli.new(
        url:    Hypgen.config.dap_url,
        verify: Hypgen.config.dap_verify,
        token:  Hypgen.config.dap_token
      )
  end

  module Api
    module V1
      autoload :Main,       'hypgen/api/v1/main'
      autoload :Experiment, 'hypgen/api/v1/experiment'
    end
  end

  autoload :Version,        'hypgen/version'
  autoload :Config,         'hypgen/config'
  autoload :Experiment,     'hypgen/experiment'
  autoload :Workflow,       'hypgen/workflow'
  autoload :Planner,        'hypgen/planner'
end

module Dap
  autoload :Cli,            'dap/cli'
end

module Exp
  autoload :Cli,            'exp/cli'
end

require 'hypgen/worker'

module RestCli

  def initialize(options = {})
    @connection = options[:connection] || initialize_connection(options)
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