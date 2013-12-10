require 'kitchen_boy/config'

module KitchenBoy
  module ConfigAware
    def config
      KitchenBoy::Config.instance
    end
  end
end
