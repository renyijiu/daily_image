require "date"
require "vips"
require "daily_image/version"
require "daily_image/lunar_solar_converter"
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

    def draw_image(output_path = nil, date = Date.today)
      output_path ||= Dir.pwd
      date = Date.parse(date.to_s) rescue Date.today

      output_file = File.join(output_path, "daily_#{date}.jpeg")

      image = DailyImage::Image.new(date: date).draw_image

      image.write_to_file(output_file, Q: 100)
    end
  end

end
