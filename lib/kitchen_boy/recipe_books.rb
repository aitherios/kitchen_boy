require 'kitchen_boy/config'
require 'kitchen_boy/logger'
require 'uri'

module KitchenBoy
  class RecipeBooks
    include KitchenBoy::Logger
    attr_accessor :config
    
    def initialize config
      @config = config
    end

    def load_recipe_books
      self.instance_eval(IO.read(@config.recipe_books_file_path))
    end

    def git repo, message = nil
      uri = URI.parse(repo)
      raise URI::InvalidURIError if uri.scheme.nil?

      @config.recipe_books << repo unless @config.recipe_books.include?(repo)

    rescue URI::Error
      message ||= "Is this git repo correct?"
      log_warning "#{message} '#{repo}'"
    end

    def github repo
      repo = "https://github.com/#{repo}.git"
      git(repo, 'Is this github shorthand correct?')
    end
  end
end
