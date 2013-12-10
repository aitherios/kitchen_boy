require 'kitchen_boy/logger'

module KitchenBoy
  class Cooker
    include Logger
    include ConfigAware

    def find_and_cook args
      name = args[0]
      recipes = []
      
      config.sources.each do |source|
        recipes.concat(KitchenBoy::RecipeBook.new(source).find(name))
      end

      load(recipes[0].path) if recipes.size == 1
    end

  end
end
