
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

      @configs = Configs.new
      #puts @configs.configs



    end

    def run
      puts "the args: #{@args}"
      parse_global_options

      if @args.empty? && @options.empty?
        say(usage)
        exit(0)
      end

      command = search_commands




    end

    def parse_global_options
      @options = {}
      opts = @option_parser

      opts.on("-v", "--version", "Show version") do
        @options[:version] = true
        say("ctt %s" % [CTT::Cli::VERSION])
        exit(0)
      end

      opts.on("-h", "--help", "Show help message") do
        @options[:help] = true
      end

      @args = @option_parser.order!(@args)
    end

    def usage
      @option_parser.to_s
    end

    def search_commands
      puts Commands.commands

    end
  end
end