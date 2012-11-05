
module CTT::Cli::Command

  USER_INPUT               = "USER_INPUT"
  TEST_SUITE_CONFIG_FILE   = "ctt.yml"

  class TestSuite < Base
    include Interactive

    def initialize(action, suite, args, runner)
      super(args, runner)
      @action = action
      @suite = suite
      @configs = @runner.configs
    end

    def run
      @action = "test" if @action == ""
      eval(@action)
    end

    def list
      puts "list #{@suite}"
      check_configuration

      suite_configs_path = File.join(@configs.configs["suites"][@suite]["location"], TEST_SUITE_CONFIG_FILE)
      suite_configs = YAML.load_file(suite_configs_path)
      unless suite_configs.is_a?(Hash)
        say("invalid yaml format for file: #{suite_configs_path}", :red)
        exit(1)
      end

      say("all subcommands for test suite: #{@suite}", :yellow)
      suite_configs["commands"].each do |command, details|
        say("#{@suite} #{command}", :green)
        say("\t#{details["desc"]}\n")
      end
    end

    def configure
      puts "configure #{@suite}"
      location = @configs.configs["suites"][@suite]["location"]
      location = "" if location == USER_INPUT
      invalid_input = true
      3.times do
        user_input = ask("suite: #{@suite} source directory:", :default => location)
        if user_input =~ /^~/
          user_input = File.expand_path(user_input)
        else
          user_input = File.absolute_path(user_input)
        end
        if Dir.exist?(user_input)
          if File.exist?(File.join(user_input, TEST_SUITE_CONFIG_FILE))
            invalid_input = false
            location = user_input
            break
          else
            say("the configure file: #{yellow(TEST_SUITE_CONFIG_FILE)} cannot be found under #{user_input}.")
          end
        else
          say("the directory: #{user_input} is invalid.")
        end
      end

      if invalid_input
        say("invalid inputs for 3 times. abort!", :red)
        exit(1)
      else
        @configs.configs["suites"][@suite]["location"] = location
        @configs.save
        say("configure suite: #{@suite} successfully.", :green)
      end
    end

    def test
      puts "test #{@suite}"
    end

    def check_configuration
      location = @configs.configs["suites"][@suite]["location"]
      if location == USER_INPUT
        say("test suite: #{@suite} is not configured. Abort", :red)
        say("please run #{yellow("configure #{@suite}")} first.")
        exit(1)
      end

      unless File.exists?(File.join(location, TEST_SUITE_CONFIG_FILE))
        say("configure file: #{TEST_SUITE_CONFIG_FILE} for test suite: #{@suite} does not exist.", :red)
        exit(1)
      end
    end
  end
end