module Hypgen
  module Worker
    class ExperimentRun
      include Sidekiq::Worker

      sidekiq_options queue: :experiment
      sidekiq_options :retry => false

      def perform(exp_id, profile_ids, rabbitmq_location, start_time, end_time, deadline)
        workflow = Workflow.new(exp_id, profile_ids, rabbitmq_location, start_time, end_time, deadline)
        setup    = Planner.new(workflow).setup
        set_id   = Hypgen.exp.start_as(setup, importance_level: 45)

        workflow.set_set_id(set_id)
        workflow.run!
      rescue Exception => e
        #some debug output
        puts e.message
        puts e.backtrace

        Hypgen.dap.update_exp(exp_id, { status: :error, status_message: e.message })
      ensure
        Hypgen.exp.stop_as(set_id)
      end
    end
  end
end