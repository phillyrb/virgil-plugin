require 'metadb_client'

class Gem::Commands::VirgilLookupCommand < Gem::Command

  VERSION = "0.0.1"
  
  def description
    'locate system packages for a gem name'
  end

  def arguments
    "PACKAGE: name of package"
  end
  
  def usage
    "#{program_name} GEM [-v VERSION] [--force] [--dep-user-install]"
  end

  def initialize
    options = { }

    super 'metadb_lookup', description, options
  end

  def execute
    get_all_gem_names.each do |name|
      unless name
        alert_error "No gem specified."
        show_help
        terminate_interaction 1
      end
    end
  end
end
