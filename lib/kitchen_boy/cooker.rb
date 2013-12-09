require 'find'
require 'kitchen_boy/logger'

module KitchenBoy
  class Cooker
    include Logger

    attr_accessor :config

    def initialize config
      @config = config
    end

    def find_and_cook args
      name = args[0]
      recipes = []
      
      config.sources.each do |source|
        recipes.concat(KitchenBoy::RecipeBook.new(config, source).find(name))
      end

      load(recipes[0].path) if recipes.size == 1
    end

  end
end
