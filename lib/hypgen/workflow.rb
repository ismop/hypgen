require 'json'

module Hypgen
  class Workflow
    def initialize(experiment_id, profile_ids, rabbitmq_location, start_time, end_time)
      @experimentId = experiment_id
      @profile_ids = profile_ids
      @start_time = start_time
      @end_time = end_time
      @rabbitmq_location = rabbitmq_location
    end

    def as_json
      @workflow_json ||= generate_workflow
    end

    def external_dependencies
      @external_dependencies ||= find_dependencies
    end

    def params
      @params ||= {
          :sections => @profile_ids.collect { |section_id| { :id => section_id.to_s } },
          :startDate => @start_time,
          :endDate => @end_time,
          :experimentId => @experimentId,
          :dapToken => Hypgen.config.dap_token,
          :dapLocation => Hypgen.config.dap_url,
          :namespace => Hypgen.config.namespace
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
      exec_string = Hypgen.config.node_location + " " + Hypgen.config.hyperflow_script_location
      puts "calling: #{exec_string} with generated workflow"
      IO.popen(exec_string, 'r+') do |pipe|
        pipe.puts(as_json_with_set_id)
        pipe.close_write
        output = pipe.read

        puts "Workflow execution output: #{output}"
      end
    end

    private

    def generate_workflow
      exec_string = Hypgen.config.node_location + " " + Hypgen.config.wfgen_script_location
      puts "calling: #{exec_string} with params: #{params.to_json}"
      IO.popen(exec_string, 'r+') do |pipe|
        pipe.puts(params.to_json)
        pipe.close_write
        output = pipe.read
      end
    end

    def find_dependencies
      [
        { configuration_template_id: Hypgen.config.config_template_id, params: { experiment_id: @experimentId, dap_token: Hypgen.config.dap_token, rabbitmq_location: @rabbitmq_location, namespace: Hypgen.config.namespace } },
      ]
    end
  end
end