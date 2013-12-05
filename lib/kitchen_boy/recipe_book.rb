require 'kitchen_boy/logger'
require 'git'
require 'uri'

module KitchenBoy
  class RecipeBook
    include KitchenBoy::Logger
    
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
      raise RuntimeError, "Home dir not writable" unless File.writable?(config.home_dir)

      uri = URI.parse(source)

      case
      when uri.scheme.nil?
        log_progress "Copying #{source}"
        FileUtils.cp_r(source, directory_path)
      when Dir.exist?(directory_path)
        log_progress "Fetching #{source}"
        g = Git.open(directory_path)
        g.pull
      else
        log_progress "Fetching #{source}"
        Git.clone(source, directory_name, path: config.home_dir)
      end

    rescue Git::GitExecuteError
      log_warning "Unable to read this git repository: #{source}"

    rescue RuntimeError
      log_warning "Home directory: #{config.home_dir} is not writable!"
    end
    
  end
end
