
module CTT::Cli
  class Configs

    COMMANDS_CONFIG_PATH = File.absolute_path(File.join(File.dirname(__FILE__), "../../config/commands.yml"))

    attr_accessor :configs

    attr_reader   :commands

    def initialize
      load
    end

    def load
      @configs = YAML.load_file(COMMANDS_CONFIG_PATH)
      @commands = @configs["commands"]
    end

    def save
      File.open(COMMANDS_CONFIG_PATH, "w") { |f| f.write YAML.dump(@configs) }
    end
  end
end