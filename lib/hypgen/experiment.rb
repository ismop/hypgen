module Hypgen
  class Experiment
    attr_reader :id

    def initialize(name, profile_ids, start_time, end_time, deadline)
      @name = name
      @profile_ids = profile_ids
      @start_time = start_time
      @end_time = end_time
      @deadline = deadline
    end

    def start!
      @id = Hypgen.dap.create_threat_assessment_run(
        @name, @profile_ids, @start_time, @end_time)

      Hypgen::Worker::ExperimentRun
        .perform_async(@id, @profile_ids, Hypgen.config.rabbitmq_location, @start_time, @end_time, @deadline)
    end
  end
end