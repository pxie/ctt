
module CTTExtensions

  def say(message, sep = "\n")
    msg = message
    puts msg
  end
end

class Object
  include CTTExtensions
end

class String
  include CTTExtensions
end