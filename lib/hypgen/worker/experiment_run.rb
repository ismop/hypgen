module Hypgen
  module Worker
    class ExperimentRun
      include Sidekiq::Worker

      sidekiq_options queue: :experiment
      sidekiq_options :retry => false

      def perform(exp_id, profile_mappings, rabbitmq_location,
                  start_time, end_time, deadline)
        Hypgen::Worker::Runner.
          new(exp_id, profile_mappings,
              rabbitmq_location,
              start_time,
              end_time,
              deadline).execute
      end
    end
  end
end
