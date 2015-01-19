module Hypgen
  module Worker
    class Runner
      include Hypgen::Auditable

      def initialize(id, profile_ids, rabbitmq_location,
                     start_time, end_time, deadline, options = {})
        @id = id
        @profile_ids = profile_ids
        @rabbitmq_location = rabbitmq_location
        @start_time = start_time
        @end_time = end_time
        @deadline = deadline
        @options = options
      end

      def execute
        set_id = nil
        audit('Running whole experiment', log_level: :info) do
          workflow = generate_workflow
          setup = plan_execution(workflow)
          set_id = start_as(setup)
          workflow.set_set_id(set_id)

          audit('Running workflow') { workflow.run! }
        end
      rescue StandardError => e
        logger.error("Experiment finished with error #{e}\n #{e.backtrace}")

        Hypgen.dap.
          update_exp(id, status: :error, status_message: e.message)
      ensure
        stop_as(set_id) if set_id
      end

      private

      attr_reader :id, :profile_ids,
                  :rabbitmq_location,
                  :start_time, :end_time,
                  :deadline, :options

      def generate_workflow
        audit('Generating workflow') do
          workflow_class.new(id, profile_ids,
                             rabbitmq_location,
                             start_time, end_time,
                             deadline)
        end
      end

      def plan_execution(workflow)
        audit('Planing workflow execution') do
          planner_class.new(workflow).setup.tap do |setup|
            logger.debug("Following vms will be created: #{setup}")
          end
        end
      end

      def start_as(setup)
        audit('Requesting appliance set with defined vm requirements') do
          exp_client.start_as(setup, importance_level: 45)
        end
      end

      def stop_as(set_id)
        audit('Stopping appliance set') { exp_client.stop_as(set_id) }
      end

      def workflow_class
        options[:workflow] || Workflow
      end

      def planner_class
        options[:planner] || Planner
      end

      def exp_client
        options[:exp_client] || Hypgen.exp
      end
    end
  end
end
