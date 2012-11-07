
module CTT::Cli::Command

  USER_INPUT               = "USER_INPUT"
  TEST_SUITE_CONFIG_FILE   = "ctt.yml"
  SUPPORT_OPTIONS          = {"--force" => "bypass git dirty state check"}

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
      check_configuration
      get_suite_configs

      say("all subcommands for test suite: #{@suite}", :yellow)
      say("Options:", :yellow)
      SUPPORT_OPTIONS.each do |opt, helper|
        say("\t[#{opt}]   \t#{helper}")
      end
      nl

      @suite_configs["commands"].each do |command, details|
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
      check_configuration
      parse_options
      check_if_dirty_state unless @options["--force"]
      get_suite_configs
      command = parse_command

      threads = []
      threads << Thread.new do
        Dir.chpwd(@configs.configs["suites"][@suite]["location"])
        say("run command: #{yellow(command)}")
        system(command)
      end

      threads.each { |t| t.join }
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

    def check_if_dirty_state
      if dirty_state?
        say("\n%s\n" % [`git status`])
        say("Your current directory has some local modifications, " +
                "please discard or commit them first.\n" +
                "Or use #{yellow("--force")} to bypass git dirty check.")
        exit(1)
      end
    end

    def dirty_state?
      `which git`
      return false unless $? == 0

      Dir.chdir(@configs.configs["suites"][@suite]["location"])
      (File.directory?(".git") || File.directory?(File.join("..", ".git"))) \
        && `git status --porcelain | wc -l`.to_i > 0
    end

    def parse_options
      @options = {}
      opts = SUPPORT_OPTIONS.keys
      @args.each do |arg|
        if opts.index(arg)
          @options[arg] = true
          @args.delete(arg)
        end
      end
    end

    def parse_command
      subcmd = ""
      if @args.empty?
        subcmd =  @suite_configs["commands"]["default"]["exec"]
      elsif @suite_configs["commands"].has_key?(@args[0])
        subcmd = @suite_configs["commands"][@args[0]]["exec"]
        @args.delete(@args[0])
      else
        say("#{@args[0]} is not invalid sub-command, run as default command")
        subcmd = @suite_configs["commands"]["default"]["exec"]
      end

      unless @args.empty?
        subcmd = subcmd + " " + @args.join(" ")
      end

      subcmd
    end

    def get_suite_configs
      suite_configs_path = File.join(@configs.configs["suites"][@suite]["location"], TEST_SUITE_CONFIG_FILE)
      @suite_configs ||= YAML.load_file(suite_configs_path)
      unless @suite_configs.is_a?(Hash)
        say("invalid yaml format for file: #{suite_configs_path}", :red)
        exit(1)
      end
      @suite_configs
    end
  end
end