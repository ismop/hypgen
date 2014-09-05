require 'faraday'

module Dap
  class Cli
    include RestCli

    def create_exp(profile_ids, start_time, end_time)
      puts "1. creating new experiment for #{profile_ids} profiles with period #{start_time} - #{end_time}"

      # TODO BW, PN: real code for creating expriment in DAP. Code from Exp::Cli
      #             can be reused here.
    end

    def update_exp(exp_id, updated_fields)
      puts "Updating #{exp_id} experiment with following fields #{updated_fields}"

      # TODO BW, PN: real code for updating experiment fields in DAP.
    end
  end
end