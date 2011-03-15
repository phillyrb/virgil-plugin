require 'rubygems/command_manager'

%w[metadb_lookup].each do |command|
  Gem::CommandManager.instance.register_command command.to_sym
end
