require 'git'
require 'uri'

module KitchenBoy
  class RecipeBook

    attr_accessor :source
    attr_accessor :config

    def initialize config, source
      @config = config
      @source = source
    end

    def directory_name
      source.gsub(/[^0-9A-Za-z-]/, '_').
             gsub(/__+/, '_').
             gsub(/^_/, '').
             downcase
    end

    def directory_path
      File.join(config.home_dir, directory_name)
    end

    def update
      uri = URI.parse(source)
      case
      when uri.scheme.nil?
        FileUtils.cp_r(source, directory_path)
      when Dir.exist?(directory_path)
        g = Git.open(directory_path)
        g.pull
      else
        Git.clone(source, directory_name, path: config.home_dir)
      end
    end
    
  end
end
