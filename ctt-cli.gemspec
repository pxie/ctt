
require File.dirname(__FILE__) + "/lib/cli/version"

Gem::Specification.new do |s|
  s.name         = "ctt-cli"
  s.version      = CTT::Cli::VERSION
  s.platform     = Gem::Platform::RUBY
  s.summary      = "CTT CLI"
  s.description  = "Common test command-line tool for testing"
  s.author       = "Pin Xie"
  s.email        = "pxie@vmware.com"
  s.homepage     = "http://www.vmware.com"

  s.files        = `git ls-files -- bin/* lib/*`.split("\n") + %w(README.md Rakefile config/commands.yml)
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = "lib"
  s.bindir       = "bin"
  s.executables  = %w(ctt)

  s.add_dependency "json_pure", "~>1.6.1"
  s.add_dependency "progressbar", "~>0.9.0"
  s.add_dependency "terminal-table", "~>1.4.2"
  s.add_dependency "paint", "~>0.8.5"
  s.add_dependency "interact", "~>0.4.8"
end
