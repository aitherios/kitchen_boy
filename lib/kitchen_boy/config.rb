require 'singleton'

module KitchenBoy
  class Config
    include Singleton

    attr_accessor :home_dir
    attr_accessor :recipe_books_filename
    
    def initialize
      @home_dir = File.join(ENV['HOME'],'.kitchen_boy')
    end

    def bootstrap_home_dir
      Dir.mkdir(@home_dir) unless Dir.exists?(@home_dir)

      Dir.chdir @home_dir do
        File.open('recipe_books', 'w') do |f|
          f.write default_recipe_books
        end
      end
    end

    private

    def default_recipe_books
      IO.read File.expand_path(File.join(File.dirname(__FILE__), 'default_recipe_books'))
    end

  end
end
