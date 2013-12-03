require 'kitchen_boy/config'

module KitchenBoy
  class RecipeBooks
    attr_accessor :config
    
    def initialize config
      @config = config
    end

    def load_recipe_books
      self.instance_eval(IO.read(@config.recipe_books_file_path))
    end

    def git repository
      @config.recipe_books << repository
    end

    def github repository
      @config.recipe_books << "https://github.com/#{repository}.git"
    end
  end
end
