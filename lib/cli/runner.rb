
module CTT::Cli

  class Runner


    # @param [Array] args
    def self.run(args)
      new(args).run
    end

    def initialize(args)
      @args = args

      banner = "Usage: ctt [<options>] <command> [<args>]"
      @option_parser = OptionParser.new(banner)
    end

    def run
      puts "the args: #{@args}"
      parse_global_options

      if @args.empty?
        say(usage)
        exit(0)
      end

      command = search_commands




    end

    def parse_global_options
      # -v is reserved for verbose but having 'bosh -v' is handy,
      # hence the little hack
      if @args.size == 1 && (@args[0] == "-v" || @args[0] == "--version")
        @args = %w(version)
        return
      end

      opts = @option_parser
      #opts.on("-c", "--config FILE", "Override configuration file") do |file|
      #  @options[:config] = file
      #end
      #opts.on("-C", "--cache-dir DIR", "Override cache directory") do |dir|
      #  @options[:cache_dir] = dir
      #end
      #opts.on("--[no-]color", "Toggle colorized output") do |v|
      #  Config.colorize = v
      #end

      opts.on("-v", "--version", "Show version") do
        @options[:version] = true
      end

      opts.on("-h", "--help", "Show help message") do
        @options[:help] = true
      end


      #opts.on("-q", "--quiet", "Suppress all output") do
      #  Config.output = nil
      #end
      #opts.on("-n", "--non-interactive", "Don't ask for user input") do
      #  @options[:non_interactive] = true
      #  Config.colorize = false
      #end
      #opts.on("-t", "--target URL", "Override target") do |target|
      #  @options[:target] = target
      #end
      #opts.on("-u", "--user USER", "Override username") do |user|
      #  @options[:username] = user
      #end
      #opts.on("-p", "--password PASSWORD", "Override password") do |pass|
      #  @options[:password] = pass
      #end
      #opts.on("-d", "--deployment FILE", "Override deployment") do |file|
      #  @options[:deployment] = file
      #end

      @args = @option_parser.order!(@args)
    end

    def usage
      @option_parser.to_s
    end

    def search_commands

    end
  end
end