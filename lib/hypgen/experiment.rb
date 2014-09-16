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
        @workflow = Workflow.new(@id, @profile_ids, @start_time, @end_time)
        setup     = Planner.new(@workflow).setup

        @set_id   = exp_cli.start_as(setup, importance_level: 45)

        @workflow.set_set_id(@set_id)

        run!
      rescue Exception => e
        #some debug output
        puts e.message
        puts e.backtrace
        dap_cli.update_exp(@id, { status: :error, status_message: e.message })
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
      #TODO MP, BB: start workflow. After workflow finished appliance set call hyperflow
      #             should be destroyed (use @set_id) and experiment status
      #             should be updated into finished (use @id).

      #TODO: this should fork to background

      # getworkflow by calling @workflow.as_json_with_set_id
      exec_string = Hypgen.config.node_location + " " + Hypgen.config.hyperflow_script_location
      puts "not calling: #{exec_string} with generated workflow"
      IO.popen(exec_string, 'r+') do |pipe|
        pipe.puts(@workflow.as_json_with_set_id)
        pipe.close_write
        output = pipe.read
      end

      puts "3. starting generated workflow"
      #should this return exp id?
    end
  end
end