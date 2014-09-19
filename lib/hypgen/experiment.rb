module Hypgen
  class Experiment
    attr_reader :id

    def initialize(name, profile_ids, start_time, end_time)
      @name = name
      @profile_ids = profile_ids
      @start_time = start_time
      @end_time = end_time
    end

    def start!
      @id = Hypgen.dap.create_exp(
        @name, @profile_ids, @start_time, @end_time)

      Hypgen::Worker::ExperimentRun
        .perform_async(@id, @profile_ids, @start_time, @end_time)
    end
  end
end