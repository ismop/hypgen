module Hypgen
  class Planner
    def initialize(workflow)
      @workflow = workflow
    end

    def setup
      # TODO MM: Real planning algorithm
      @workflow.external_dependencies.map do |appl|
        {
          init_conf_tmp_id: appl[:init_conf_tmp_id],
          params: appl[:init_conf_tmp_id],
          vms: [
            { cpu: 1, mem: 512 },
            { cpu: 2, mem: 1024 }
          ]
        }
      end
    end
  end
end