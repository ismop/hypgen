require 'sidekiq'

module Hypgen
  module Worker
    autoload :ExperimentRun, 'hypgen/worker/experiment_run'
  end
end

Sidekiq.configure_server do |config|
  config.redis = {
      namespace: Hypgen.config.namespace,
      url: Hypgen.config.redis_url
    }
end

Sidekiq.configure_client do |c|
  c.redis = {
      namespace: Hypgen.config.namespace,
      url: Hypgen.config.redis_url
    }
end

puts "Connecting to #{Hypgen.config.redis_url} with #{Hypgen.config.namespace} namespace"