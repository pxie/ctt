
def use_io(cmd)
  IO.popen(cmd, :err =>[:child, :out]) do |io|
    output << io.read
    puts output
  end
end

def use_system(cmd)
  system(cmd)
  puts $stdout
end

def use_exec(cmd)
  exec(cmd) if fork == nil
  Process.wait
end


threads = []
cmd = "ruby sleep.rb"

output = ""
threads << Thread.new do
  #use_exec(cmd)
  #use_system(cmd)
  require 'pty'
  begin
    PTY.spawn(cmd) do |stdin, stdout, pid|
      begin
        stdin.each { |line| print line }
      rescue Errno::EIO
      end
      puts "==========\n#{stdout.read}\n===========\n#{pid}\n============"
    end
  rescue PTY::ChildExited
    puts "The child process exited!"
  end
end

threads.each { |t| t.join }



#use_system(cmd)

puts "parent finish"
File.expand_path


