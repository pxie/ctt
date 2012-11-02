
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

      @commands = Configs.new.commands
      #@commands = Commands.commands.merge(Configs.new.commands)
      #@configs = Configs.new
      #puts @configs.configs



    end

    def run
      puts "the args: #{@args}"
      parse_global_options

      if @args.empty? && @options.empty?
        say(usage)
        exit(0)
      end

      find, command = search_commands
      err("invalid command. abort!") unless find

      execute(command)

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
        @args << "help"
      end

      @args = @option_parser.order!(@args)
    end

    def usage
      @option_parser.to_s
    end

    def search_commands
      cmds = @commands.keys

      find = nil
      longest_cmd = ""
      args = []
      size = @args.size
      size.times do |index|

        longest_cmd = @args[0..(size - index - 1)].join(" ")
        find = cmds.index(longest_cmd)
        if find
          args = @args[(size - index)..-1]
        end

      end
      [find, longest_cmd, args]
    end

    def execute(command)
      eval("#{command}(args)")
    end
  end
end