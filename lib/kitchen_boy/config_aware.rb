module KitchenBoy::ConfigAware
  def config
    KitchenBoy::Config.instance
  end
end
