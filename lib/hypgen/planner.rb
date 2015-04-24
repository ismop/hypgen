require 'json'
require 'recursive-open-struct'


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


    def count_processes(wf)
      wf.processes.count{ |p| p.name.start_with?("ComputeScenarioRanks") }
    end

    def compute_levels
      # compute levels of the DAG
      wf_hash = JSON.parse(@workflow.as_json)
      wf = RecursiveOpenStruct.new(wf_hash,:recurse_over_arrays => true)
      dag = create_dag(wf)
      level = Hash.new
      dag.topsort_iterator.each{ |v| level[v]=0 }
      dag.topsort_iterator.each{ |v|
        dag.adjacent_vertices(v).each{ |c|
          level[c] = level[v] + 1 if level[c] <= level[v]
        }
      }
      dag.topsort_iterator.each{ |v| puts "#{v}: level #{level[v]}" }
      pp level
      wf_hash['processes'].each do|p|
        p['level'] = level[p['name']]
      end
      puts JSON.pretty_generate wf_hash
      level
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


      # Optional decoration of workflow with levels
      dag = Dag.new(@workflow.as_json)
      levels = dag.compute_levels
      pp levels
      dag.decorate_levels (levels)
      puts dag.to_json
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