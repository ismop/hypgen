module Hypgen
  class Experiment
    attr_reader :id

    def initialize(profile_ids, start_time, end_time)
      @profile_ids = profile_ids
      @start_time = start_time
      @end_time = end_time
    end

    def start!
      @id = Dap::Cli.create_experiment(
        @profile_ids, @start_time, @end_time)

      @workflow = Workflow.new(@profile_ids, @start_time, @end_time)
      setup     = Planner.new(@workflow).setup

      @set_id   = exp_cli.start_as(setup, importance_level: 45)

      run!
    end

    private

    def exp_cli
      @exp_cli ||= Exp::Cli.new(
          url:    Hypgen.config.exp_url,
          verify: Hypgen.config.exp_verify,
          token:  Hypgen.config.exp_token
        )
    end

    def run!
      #TODO MP, BB: start workflow. After workflow finished appliance set
      #             should be destroyed (use @set_id) and experiment status
      #             should be updated into finished (use @id).
      puts "3. starting generated workflow"
    end
  end
end