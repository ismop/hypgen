require "hypgen/version"

module Hypgen
  module Api
    module V1
      autoload :Main,       'api/v1/main'
      autoload :Experiment, 'api/v1/experiment'
    end
  end

  autoload :Experiment,     'hypgen/experiment'
  autoload :Workflow,       'hypgen/workflow'
  autoload :Planner,        'hypgen/planner'
end

module Dap
  autoload :Cli,            'dap/cli'
end

module Exp
  autoload :Cli,            'exp/cli'
end