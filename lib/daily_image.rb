require "date"
require "vips"
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

    def draw_image(output_path = nil)
      output_path ||= Dir.pwd
      output_file = File.join(output_path, "daily_#{Date.today}.jpeg")

      image = DailyImage::Image.new.draw_image

      image.write_to_file(output_file, Q: 100)
    end
  end

end
