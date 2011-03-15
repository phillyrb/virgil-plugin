require 'yaml'

module MetaDB
  class GemMap
    attr_reader :mapping

    def initialize(file = File.join(File.dirname(File.expand_path(__FILE__)), 'gem_map.yaml'))
      @mapping = YAML.load_file(file)
    end

    def lookup(gem)
      @mapping[gem.to_s]
    end
  end
end
