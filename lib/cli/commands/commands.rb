
module CTT::Cli
  module Commands
    commands = {"help" =>
                  {"usage"  => "help",
                   "desc"   => "list all avaiable commands"},
                "aliases" =>
                    {"usage"  => "aliases",
                     "desc"   => "Show the list of available command aliases"},
                "add alias" =>
                    {"usage"  => "add alias <name> <commands>",
                     "desc"   => "organize multiple tests under one alias"},
                "delete alias" =>
                    {"usage"  => "delete alias <name>",
                     "desc"   => "remove alias"},
                }
  end
end