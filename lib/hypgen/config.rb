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

    private

    def default_config_path
      File.join(ROOT_PATH, 'config.yml')
    end

    def load_config(config_path)
      if File.exists?(config_path)
        @config = YAML.load_file(config_path)
      else
        @config = {exp: {}}
      end
    end
  end
end