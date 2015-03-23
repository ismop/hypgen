require 'json'
require 'recursive-open-struct'

module Hypgen
  class Planner

    def initialize(workflow)
      @workflow = workflow
      @deadline = @workflow.deadline
      @constant_term = 40
    end


    # Our performance model
    # Model Parameters:
    # T - time in seconds
    # s - number of sections
    # d - number of days (window size)
    # v - number of VMs
    #
    # Function parameters obtained from fit to data:
    # a = 6.53
    # b = 9.41
    # c = 31.71
    #
    # Function:
    # T = a * s * d / v + b * v + c
    #
    # This can be solved to find v:
    # b * v^2 + (c-T) * v + a * s * d = 0
    # This gives:
    #
    # v = (-(c-T) +/- sqrt((c-T)^2 -4 * b * a * s *d)) / (2 * b)
    # Out of two solutions we select the smaller one, so:
    # v = (-(c-T) - sqrt((c-T)^2 - 4 * b * a * s *d)) / (2 * b)
    #
    def estimate_vm_count(wf)

      a = 6.53
      b = 9.41
      c = 31.71

      s = count_processes(wf)
      d = 1 # Fixme: how can we get the number of days from the workflow?
      t = @deadline

      delta = (c-t)*(c-t) - 4 * b * a * s *d

      delta = 0.0 if delta<0

      vmc = (-(c-t) - sqrt(delta)) / (2 * b)

      vmc.ceil

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