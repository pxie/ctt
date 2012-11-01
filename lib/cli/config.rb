
module CTT::Cli
  class Config

    COMMANDS_CONFIG_PATH = File.absolute_path(File.join(File.dirname(__FILE__), "../config"))

    attr_accessor :configs

    def initialize
      if File.exists?(COMMANDS_CONFIG_PATH)
        @configs = YAML.load_file(COMMANDS_CONFIG_PATH)
        raise "Invalid config file format, #{COMMANDS_CONFIG_PATH}" unless @configs.is_a?(Hash)
      else
        @configs = {}
      end
    end

    def save

    end

  end
end