require 'json'

module Hypgen
  class Workflow
    def initialize(experiment_id, profile_ids, start_time, end_time)
      @id = experiment_id
      @profile_ids = profile_ids
      @start_time = start_time
      @end_time = end_time
    end

    def as_json
      @workflow_json ||= generate_workflow
    end

    def external_dependencies
      @external_dependencies ||= find_dependencies
    end

    def params
      @params ||= {
          :sections => @profile_ids.collect { |id| { :id => id.to_s, :simdata => "simset0001"} },
          :timeWindow => "24"
      }
    end

    def set_set_id(as_id)
      @set_id = as_id
    end

    def as_json_with_set_id
      #use only in last step when generating wf for HF!
      wf = @workflow_json || generate_workflow
      wf.sub("$$AS_ID$$", @set_id)
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
          #init_conf_tmp_id 7: worker_conf
        { init_conf_tmp_id: 7, params: { id: @id, dap_token: Hypgen.config.dap_token } },
      ]
    end
  end
end