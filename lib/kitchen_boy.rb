require 'kitchen_boy/version'
require 'singleton'

class KitchenBoy
  include Singleton

  attr_accessor :home_dir
  attr_accessor :recipe_books_filename
  
  def initialize
    @home_dir = File.join(ENV['HOME'],'.kitchen_boy')
  end

  def default_recipe_books
    IO.read File.expand_path(File.join(File.dirname(__FILE__), 'kitchen_boy', 'default_recipe_books'))
  end

  def bootstrap_home_dir
    Dir.mkdir(@home_dir) unless Dir.exists?(@home_dir)

    Dir.chdir @home_dir do
      File.open('recipe_books', 'w') do |f|
        f.write default_recipe_books
      end
    end

  end
end
