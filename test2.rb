require 'optparse'

options = {}
opt = OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end

args = ARGV.dup

options = opt.parse(args)

puts opt
puts args


p options
p ARGV