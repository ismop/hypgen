require 'json'
require 'recursive-open-struct'
require 'rgl/adjacency'
require 'rgl/dot'

module Hypgen
  class Planner

    def initialize(workflow)
      @workflow = workflow
      @deadline = @workflow.deadline
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

    def create_dag(wf)
      dag = RGL::DirectedAdjacencyGraph.new
      wf.processes.each do|p|
        p.outs.each do |o|
          child = wf.processes.find{ |c| c.ins.include? o}
          puts "#{p.name} --[#{o}]--> #{child.name}"
          dag.add_edge(p.name, child.name)
        end
      end
      #dag.write_to_graphic_file('png')
    end

    def count_processes(wf)
      wf.processes.count{ |p| p.name.start_with?("ComputeScenarioRanks") }
    end

    def setup

      wf_hash = JSON.parse(@workflow.as_json)
      wf = RecursiveOpenStruct.new(wf_hash,:recurse_over_arrays => true)

      vm_count = estimate_vm_count(wf)

      puts "Estimated VM count: #{vm_count}"

      vms = Array.new
      for i in 1..vm_count
        vms.push ( { cpu: 1, mem: 512 })
      end

      #puts vms

      create_dag(wf)

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