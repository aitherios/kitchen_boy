module KitchenBoy
  class RecipeBook

    attr_accessor :source
    attr_accessor :config

    def initialize config, source
      @config = config
      @source = source
    end

    def directory_name
      @source.gsub(/[^0-9A-Za-z-]/, '_').gsub(/__+/, '_').downcase
    end
    
  end
end
