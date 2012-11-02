
module CTTExtensions

  def say(message, color = nil, sep = "\n")
    msg = message
    puts Paint[msg, color]
  end

  def err(message)
    raise CTT::Cli::CliError, message
  end
end

class Object
  include CTTExtensions
end
