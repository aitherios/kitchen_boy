module KitchenBoy
  class Recipe
    include Comparable

    attr_accessor :path, :recipe_book

    def initialize path, recipe_book
      @path = path
      @recipe_book = recipe_book
    end

    def <=> other
      case
      when self.path < other.path; -1
      when self.path > other.path; 1
      when self.path == other.path && self.recipe_book == other.recipe_book; 0
      else -1
      end
    end
  end
end
