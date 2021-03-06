require 'json'

module Hypgen
  class Workflow
    attr_accessor :deadline
    attr_accessor :start_time
    attr_accessor :end_time

    def initialize(experiment_id, profile_mappings, rabbitmq_location, start_time, end_time, deadline)
      @experimentId = experiment_id
      @profile_mappings = profile_mappings
      @start_time = start_time
      @end_time = end_time
      @rabbitmq_location = rabbitmq_location
      @deadline = deadline # in seconds
    end

    def as_json
      @workflow_json ||= generate_workflow
    end

    def external_dependencies
      @external_dependencies ||= find_dependencies
    end

    def params
      @params ||= {
        profile_mappings: @profile_mappings,
        startDate: @start_time,
        endDate: @end_time,
        experimentId: @experimentId,
        dapToken: config.dap_token,
        dapLocation: config.dap_url,
        namespace: config.namespace,
        contextId: nil,
        scenarioId: nil,
        executable: "comparing.bin"
      }
    end

    def set_set_id(application_set_id)
      @set_id = application_set_id
    end

    def as_json_with_set_id
      #use only in last step when generating wf for HF!
      wf = @workflow_json || generate_workflow
      wf.sub("$$AS_ID$$", @set_id.to_s)
    end

    def run!
      puts "3. starting generated workflow"
      exec_string = node_exec(config.hyperflow_script_location)
      puts "calling: #{exec_string} with generated workflow"
      IO.popen(exec_string, 'r+') do |pipe|
        pipe.puts(as_json_with_set_id)
        pipe.close_write
        output = pipe.read

        puts "Workflow execution output: #{output}"
        pipe.close
        $?.to_i
      end
    end

    private

    #TODO: unused
    def sections
      @profile_ids.map { |section_id| { id: section_id.to_s } }
    end

    def generate_workflow
      exec_string = node_exec(config.wfgen_script_location)
      puts "calling: #{exec_string} with params: #{params.to_json}"
      IO.popen(exec_string, 'r+') do |pipe|
        pipe.puts(params.to_json)
        pipe.close_write
        output = pipe.read
      end
    end

    def node_exec(script)
      "#{config.node_location} #{script}"
    end

    def find_dependencies
      [
        {
          configuration_template_id: config.config_template_id,
          params: {
            experiment_id: @experimentId,
            dap_token: config.dap_token,
            rabbitmq_location: @rabbitmq_location,
            namespace: config.namespace
          }
        }
      ]
    end

    def config
      Hypgen.config
    end
  end
end
