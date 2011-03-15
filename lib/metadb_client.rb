require 'metadb_gem_map'
require 'yaml'
require 'rbconfig'

module MetaDB
  class Client
    METADB_CONFIG_FILE = File.expand_path("~/.metadb.yaml")
    
    RUBY_PLATFORM_MATCHER = { 
      /darwin/  => 'osx',
      /mingw/   => 'mingw',
      /mswin/   => 'mswin', 
      /freebsd/ => 'freebsd',
    }

    PACKAGE_MANAGER_MAP = {
      'osx'   => %w[fink macports homebrew],
      'mingw' => %w[],
      'mswin' => %w[],
      'freebsd' => %w[ports],
    }

    attr_reader :driver
    attr_reader :gem_map
    attr_reader :config

    def initialize(driver = MetaDB::Client::File.new, gem_map = MetaDB::GemMap.new)
      @driver = driver
      @gem_map = gem_map
      @config = File.exist?(METADB_CONFIG_FILE) ? YAML.load_file(METADB_CONFIG_FILE) : nil
    end

    def lookup(os, pm, cname)
      @driver.lookup(os, pm, cname)
    end

    def lookup_for_gem(gem)
      os = get_platform
      pm = get_package_manager(os)

      lookup(@gem_map.lookup(gem))
    end

    def get_package_manager(os)
      if @config and @config["package_manager"]
        return @config["package_manager"]
      end

      pm = PACKAGE_MANAGER_MAP[os]

      unless pm.length != 1
        raise "We could not determine your package manager. Please supply a package manager in #{METADB_CONFIG_FILE}."
      end

      return pm.first
    end

    def get_platform
      if @config and @config["platform"]
        return @config["platform"]
      end

      platform = case RUBY_PLATFORM
                 when /linux/
                   find_linux
                 end

      unless platform
        platform = RUBY_PLATFORM_MATCHER.select do |regex, value| 
          RUBY_PLATFORM =~ regex 
        end.first
      end

      unless platform
        raise "Could not determine platform: #{RUBY_PLATFORM}: please submit a bug!"
      end

      return platform
    end

    def find_linux
      # scan /etc/issue
      
      issue = File.read('/etc/issue')

      return case issue
              when /CentOS/i
                  'centos'
              when /Debian/i
                  'debian'
              when /Ubuntu/i
                  'ubuntu'
              when /RedHat/i
                  'redhat'
              when /Arch/i
                  'arch'
              when /Slackware/i
                  'slackware'
              else
                nil
              end
    end
  end

  class Client::File

    attr_reader :map

    def initialize(file = File.join(File.dirname(File.expand_path(__FILE__)), 'metadb.yaml'))
      @map = YAML.load_file(file)
    end

    def lookup(os, pm, cname)
      @map[os][pm][cname] rescue nil 
    end
  end
end
