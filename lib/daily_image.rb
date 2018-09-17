require "daily_image/version"
require "daily_image/poem"
require "daily_image/image"
require "daily_image/config"

module DailyImage

  class << self
    def configure
      config = DailyImage::Config.instance
      yield config
    end

    def config
      DailyImage::Config.instance.configuration
    end
  end


end
