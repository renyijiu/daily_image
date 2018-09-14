require "date"
require "vips"

module DailyImage
  class Image

    def initialize(width = 600, height = 800)
      @width = width
      @height = height
    end

    def draw_image
      output = File.join(Dir.pwd, "daily_#{Date.today}.jpg" )

      image = Vips::Image.black(@width, @height)
      image = draw_top_half(image)

      image.write_to_file(output, Q: 100)
    end

    private

    def draw_top_half(image)
      image = draw_background(image)
      image = draw_frame(image)
      image = draw_day(image)
      image = draw_date(image)
      image = draw_week(image)
      image = draw_progress_txt(image)

      draw_progress(image)
    end

    # 设置背景颜色
    def draw_background(image)
      bg_color = [255, 255, 255]

      image + bg_color
    end

    # 画出外边框
    def draw_frame(image)
      frame_color = [151, 158, 161]

      [15, 16, 17, 18, 19, 25, 26].each do |offset|
        width = @width - 2 * offset
        height = @height - 2 * offset

        image = image.draw_rect(frame_color, offset, offset, width, height, fill: false)
      end

      image
    end

    # 画出中间日期
    def draw_day(image)
      day = Date.today.day.to_s

      # 生成字体图片
      text = generate_text_image(day, dpi: 900)

      # 计算字体放置位置
      x = (image.width - text.width) / 2
      y = (image.height * 0.2).to_i

      image.draw_image text, x, y, mode: :set
    end

    # 画出左上角日期
    def draw_date(image)
      date = Date.today.to_s

      text = generate_text_image(date, dpi: 150)

      # 计算放置位置
      x = (image.width * 0.1).to_i
      y = (image.height * 0.1).to_i

      image.draw_image text, x, y, mode: :set
    end

    # 画出右上角信息
    def draw_week(image)
      week_arr = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
      week = week_arr[Date.today.cwday]

      text = generate_text_image(week, dpi: 150)

      # 计算放置位置
      x = (image.width * 0.75).to_i
      y = (image.height * 0.1).to_i

      image.draw_image text, x, y, mode: :set
    end

    # 画出进度描述信息
    def draw_progress_txt(image)
      day = Date.today.yday
      percent = (percent_of_year * 100).round(2)
      text = "第 #{day} 天，进度已消耗 #{percent}%"

      # 获取文字图片
      text_image = generate_text_image(text)

      x = (@width - text_image.width) / 2
      y = @height * 0.4

      image.draw_image text_image, x, y, mode: :set
    end

    # 画出年进度信息
    def draw_progress(image)
      unused_color = [200, 205, 215]
      used_color = [100, 145, 170]
      offset = @width * 0.1
      height = 30

      unused_width = @width - 2 * offset
      used_width = (unused_width * percent_of_year).to_i

      x = offset
      y = (@height * 0.45).to_i

      # 画出整年的进度条
      image = image.draw_rect(unused_color, x, y, unused_width, height, fill: true)

      # 画出已进行的进度条
      image.draw_rect(used_color, x, y, used_width, height, fill: true)
    end

    def percent_of_year
      year = Date.today.year
      days = Date.new(year, 12, 31).yday
      current_days = Date.today.yday

      (current_days.to_f / days).round(4)
    end

    # 生成字体图片
    def generate_text_image(text, opts={})
      dpi = opts.fetch(:dpi, 100)
      text_color = opts.fetch(:text_color, [100, 145, 170])
      bg_color = opts.fetch(:bg_color, [255, 255, 255])

      text_image = Vips::Image.text text, dpi: dpi, font: 'Arial'
      text_image = text_image.embed 0, 0, text_image.width, text_image.height

      text_image.ifthenelse(text_color, bg_color, blend: true)
    end

  end
end