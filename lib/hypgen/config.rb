require 'yaml'

module Hypgen
  class Config
    def initialize(path)
      load_config(path)
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
      @config['worker_config_template_id']
    end

    def rabbitmq_location
      @config['rabbitmq_location']
    end

    def namespace
      @config['worker']['namespace'] || 'hypgen'
    end

    def redis_url
      @config['worker']['redis_url'] || 'redis://localhost:6379'
    end

    def log_dir
      @config['logs']['dir'] || '.'
    end

    def trace?
      @config['logs']['trace']
    end

    private

    def load_config(config_path)
      if File.exists?(config_path)
        @config = YAML.load_file(config_path)
      else
        @config = {
          'exp' => {},
          'dap' => {},
          'worker' => {},
          'logs' => {}
        }
      end
    end
  end
end
