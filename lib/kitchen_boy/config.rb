module KitchenBoy
  class Config
    DEFAULT_RECIPE_BOOK = 'https://github.com/aitherios/kitchen_boy_recipe_book.git'
    
    attr_accessor :home_dir
    attr_accessor :sources
    
    def initialize home_dir = nil
      @home_dir = home_dir || File.join(ENV['HOME'],'.kitchen_boy')
      @sources = [DEFAULT_RECIPE_BOOK]
    end

    def recipe_books_file_path
      File.join(@home_dir, 'recipe_books')
    end

    def bootstrap_home_dir
      Dir.mkdir(@home_dir) unless Dir.exists?(@home_dir)

      File.open(recipe_books_file_path, 'w') do |f|
        f.write default_recipe_books
      end unless File.exists?(recipe_books_file_path)

      true
    rescue
      false
    end

    private

    def default_recipe_books
      IO.read File.expand_path(File.join(File.dirname(__FILE__), 'default_recipe_books'))
    end

  end
end
