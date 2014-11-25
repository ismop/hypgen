require 'json'
require 'recursive-open-struct'

module Hypgen
  class Planner

    def initialize(workflow)
      @workflow = workflow
      # FIXME the deadline should be given in parameters
      @deadline = 60
      @constant_term = 40
    end

    def estimate_task_runtime
      # return current estimation from the experiments
      9.345820862
    end

    def estimate_vm_count(wf)
      vmc = count_processes(wf) * estimate_task_runtime / ( @deadline - @constant_term)
      vmc.ceil
      # FIXME for production let's be safe
      3
    end

    def count_processes(wf)
      wf.processes.count{ |p| p.name.start_with?("ComputeScenarioRanks") }
    end

    def setup
      # TODO MM: Real planning algorithm

      wf_hash = JSON.parse(@workflow.as_json)
      wf = RecursiveOpenStruct.new(wf_hash,:recurse_over_arrays => true)

      vm_count = estimate_vm_count(wf)

      puts "Estimated VM count: #{vm_count}"

      vms = Array.new
      for i in 1..vm_count
        vms.push ( { cpu: 1, mem: 512 })
      end

      #puts vms

      @workflow.external_dependencies.map do |appl|
        {
          configuration_template_id: appl[:configuration_template_id],
          params: appl[:params],
          vms: vms
        }
      end
    end
  end
end