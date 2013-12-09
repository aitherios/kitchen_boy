require 'find'
require 'kitchen_boy/logger'

module KitchenBoy
  class Cooker
    include Logger

    attr_accessor :config

    def initialize config
      @config = config
    end

    def find name
      name = Regexp.escape(name.strip)
      found = []
      Find.find(config.home_dir) do |path|
        if File.basename(path) =~ /^#{name}.*/i and File.file?(path)
          found << path
        end
      end
      found
    end

    def run name
      file = self.find(name).first
      if File.file?(file)
        load(file)
      end
    end
  end
end
