
module DailyImage
  class Image

    def initialize(width = 600, height = 800, date: Date.today)
      @width = width
      @height = height
      @date = date
    end

    def draw_image
      image = Vips::Image.black(@width, @height)
      image = draw_top_half(image)

      draw_down_half(image)
    end

    private

    def config
      @config ||= DailyImage.config
    end

    # 画出上半部分
    def draw_top_half(image)
      image = draw_background(image)
      image = draw_frame(image)
      image = draw_day(image)
      image = draw_date(image)
      image = draw_week(image)
      image = draw_progress_txt(image)

      draw_progress(image)
    end

    # 画出下半部分
    def draw_down_half(image)
      image = draw_down_frame(image)

      draw_poem(image)
    end

    # 设置背景颜色
    def draw_background(image)
      image + config[:bg_color]
    end

    # 画出外边框
    def draw_frame(image)
      [0, 1, 2, 3, 4, 10, 11].each do |offset|
        offset += config[:out_frame_offset]

        width = @width - 2 * offset
        height = @height - 2 * offset

        image = image.draw_rect(config[:frame_color], offset, offset, width, height, fill: false)
      end

      image
    end

    # 画出中间日期
    def draw_day(image)
      day = @date.day.to_s

      # 生成字体图片
      text = generate_text_image(day, dpi: 1000, text_color: config[:date_color])

      # 计算字体放置位置
      x = (image.width - text.width) / 2
      y = (image.height * 0.2).to_i

      image.draw_image text, x, y, mode: :set
    end

    # 画出左上角日期
    def draw_date(image)
      date = @date.to_s
      text = generate_text_image(date, dpi: 150)

      # 计算放置位置
      x = (image.width * 0.1).to_i
      y = (image.height * 0.09).to_i

      image.draw_image text, x, y, mode: :set
    end

    # 画出右上角信息
    def draw_week(image)
      week_arr = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日']
      week = week_arr[@date.cwday - 1]

      text = generate_text_image(week, dpi: 140)

      # 计算放置位置
      x = (image.width * 0.75).to_i
      y = (image.height * 0.09).to_i

      image.draw_image text, x, y, mode: :set
    end

    # 画出进度描述信息
    def draw_progress_txt(image)
      day = @date.yday
      percent = (percent_of_year * 100).round(2)
      text = "第 #{day} 天，进度已消耗 #{percent}%"

      # 获取文字图片
      text_image = generate_text_image(text)

      x = (@width - text_image.width) / 2
      y = @height * 0.44

      image.draw_image text_image, x, y, mode: :set
    end

    # 画出年进度信息
    def draw_progress(image)
      height = 30

      unused_width = @width - 2 * config[:in_frame_offset]
      used_width = (unused_width * percent_of_year).to_i

      x = config[:in_frame_offset]
      y = (@height * 0.5).to_i

      # 画出整年的进度条
      image = image.draw_rect(config[:unused_color], x, y, unused_width, height, fill: true)

      # 画出已进行的进度条
      image.draw_rect(config[:used_color], x, y, used_width, height, fill: true)
    end

    # 画出下半部分边框
    def draw_down_frame(image)
      width = (@width - 2 * config[:in_frame_offset]).to_i
      height = (@height * 0.49 - 2 * config[:in_frame_offset]).to_i

      x = config[:in_frame_offset]
      y = (@height * 0.51 + config[:in_frame_offset]).to_i

      image.draw_rect(config[:frame_color], x, y, width, height, fill: false)
    end

    def draw_poem(image)
      _, res = DailyImage::Poem.new.txt

      title = res['origin'] || '无题'
      content = res['content'] || '唯有梦想与爱情，不可辜负。'
      author = "--- #{res['author'] || '佚名'}"

      image = draw_poem_title(image, title)
      image = draw_poem_content(image, content)
      draw_poem_author(image, author)
    end

    def draw_poem_title(image, title)
      text = generate_text_image(title, dpi: 110)

      x = ((@width - text.width) / 2).to_i
      y = (@height * 0.65).to_i

      image.draw_image text, x, y, mode: :set
    end

    def draw_poem_content(image, content)
      text = generate_text_image(content, dpi: 135)

      x = ((@width - text.width) / 2).to_i
      y = (@height * 0.75).to_i

      image.draw_image text, x, y, mode: :set
    end

    def draw_poem_author(image, author)
      text = generate_text_image(author)

      x = (@width - text.width - config[:in_frame_offset] - 10).to_i
      y = (@height * 0.85).to_i

      image.draw_image text, x, y, mode: :set
    end

    # 计算当天时间在一年的百分比
    def percent_of_year
      days = Date.new(@date.year, 12, 31).yday
      current_days = @date.yday

      (current_days.to_f / days).round(4)
    end

    # 生成字体图片
    def generate_text_image(text, opts={})
      dpi = opts.fetch(:dpi, 100)
      text_color = opts.fetch(:text_color, config[:text_color])
      bg_color = opts.fetch(:bg_color, config[:bg_color])
      font = opts.fetch(:font, config[:font])

      text_image = Vips::Image.text text, dpi: dpi, font: font
      text_image = text_image.embed 0, 0, text_image.width, text_image.height, extend: :mirror

      text_image.ifthenelse(text_color, bg_color, blend: true)
    end

  end
end