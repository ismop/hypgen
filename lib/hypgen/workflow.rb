module Hypgen
  class Workflow
    def initialize(profile_ids, start_time, end_time)
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

    private

    def generate_workflow
      #TODO MP: Real workflow generation.
    end

    def find_dependencies
      # TODO MP: At the beginning this dependencies can be hardcoded
      #          Example created above will start VPH WebDRS
      [
        { init_conf_tmp_id: 614, params: { channel: 'exp1' } },
        #...
      ]
    end
  end
end