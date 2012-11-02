
module CTT::Cli::Command

  class TestSuite

    def initialize(action, suite, args, runner)
      super(args, runner)
      @action = action
      @suite = suite
    end

    def run
      @action = "test" if @action == ""
      eval(@action)
    end

    def list
      puts "list #{@suite}"
    end

    def configure
      puts "configure #{@suite}"
    end

    def test
      puts "test #{@suite}"
    end

  end
end