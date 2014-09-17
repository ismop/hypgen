require 'yaml'

ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

module Hypgen
  class Config
    def initialize(path = nil)
      load_config(path || default_config_path)
    end

    def exp_url
      @config['exp']['url']
    end

    def exp_token
      @config['exp']['token']
    end

    def exp_verify
      @config['exp']['verify']
    end

    def dap_url
      @config['dap']['url']
    end

    def dap_token
      @config['dap']['token']
    end

    def dap_verify
      @config['dap']['verify']
    end

    def username
      @config['username']
    end

    def password
      @config['password']
    end

    def node_location
      @config['node_location']
    end

    def wfgen_script_location
      @config['wfgen']['script_location']
    end

    def hyperflow_script_location
      @config['hyperflow']['script_location']
    end

    def config_template_id
      @config['worker_config_template_id'].to_i
    end

    private

    def default_config_path
      File.join(ROOT_PATH, 'config.yml')
    end

    def load_config(config_path)
      if File.exists?(config_path)
        @config = YAML.load_file(config_path)
      else
        @config = { exp: {}, dap: {} }
      end
    end
  end
end