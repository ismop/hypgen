module Hypgen
  class Experiment
    attr_reader :id

    def initialize(profile_ids, start_time, end_time)
      @profile_ids = profile_ids
      @start_time = start_time
      @end_time = end_time
    end

    def start!
      @id = dap_cli.create_exp(
        @profile_ids, @start_time, @end_time)

      begin
        @workflow = Workflow.new(@profile_ids, @start_time, @end_time)
        setup     = Planner.new(@workflow).setup

        @set_id   = exp_cli.start_as(setup, importance_level: 45)

        run!
      rescue Exception => e
        dap_cli.update_exp(@id, { status: :error, error_message: e.message })
      end
    end

    private

    def exp_cli
      @exp_cli ||= Exp::Cli.new(
          url:    Hypgen.config.exp_url,
          verify: Hypgen.config.exp_verify,
          token:  Hypgen.config.exp_token
        )
    end

    def dap_cli
      @dap_cli ||= Dap::Cli.new(
          url:    Hypgen.config.dap_url,
          verify: Hypgen.config.dap_verify,
          token:  Hypgen.config.dap_token
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