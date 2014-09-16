require 'json'
require 'recursive-open-struct'

module Hypgen
  class Planner
    def initialize(workflow)
      @workflow = workflow
    end


    def estimate_vm_count(wf)
      count_processes(wf) / 100 + 2
    end

    def count_processes(wf)
      wf.processes.count
    end

    def setup
      # TODO MM: Real planning algorithm

      wf_hash = JSON.parse(@workflow.as_json)
      wf = RecursiveOpenStruct.new(wf_hash)

      vm_count = estimate_vm_count(wf)

      puts "Estimated VM count: #{vm_count}"

      vms = Array.new
      for i in 1..vm_count
        vms.push ( { cpu: 1, mem: 512 })
      end

      #puts vms

      @workflow.external_dependencies.map do |appl|
        {
          init_conf_tmp_id: appl[:init_conf_tmp_id],
          params: appl[:init_conf_tmp_id],
          vms: vms
        }
      end
    end
  end
end