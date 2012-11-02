
#puts ARGV
## find the longest command

#li = ["help", "add alias", "delete alias", "yeti", "aliases", "add alias"]
#
#puts li[0..1].join(", ")
#puts li[1 + 1..-1].join(", ")
#
#puts "xxxxxxx333"
#
#inputs = ["help -v", "add yeti", "yeti rake full[1] VCAP=true", "aliases", "add alias sef sdf e ste"]
#
#inputs.each do |i|
#
#  pieces = i.split(" ")
#  size = pieces.size
#  find = nil
#  longest_cmd = ""
#  size.times do |index|
#
#    longest_cmd = pieces[0..(size - index - 1)].join(" ")
#    find = li.index(longest_cmd)
#    break if find
#  end
#
#  puts "input is #{i}"
#  if find
#    puts longest_cmd
#  else
#    puts "invalid command"
#  end
#  puts "================="
#end

class Help

  def initialize(args)
    @args = args.dup
  end

  def run
    puts "#{self}, #{@args}"
  end
end

