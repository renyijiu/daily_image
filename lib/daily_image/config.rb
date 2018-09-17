require "singleton"

module DailyImage
  class Config
    include Singleton

    # 背景颜色
    attr_accessor :bg_color

    # 边框颜色
    attr_accessor :frame_color

    # 文字颜色
    attr_accessor :text_color

    # 中间日期颜色
    attr_accessor :date_color

    # 进度条未使用颜色
    attr_accessor :unused_color

    # 进度条已使用颜色
    attr_accessor :used_color

    # 文字默认字体
    attr_accessor :font

    def configuration
      @config ||= {}.tap do |config|
        config[:bg_color] = bg_color || [255, 255, 255]
        config[:frame_color] = frame_color || [151, 158, 160]
        config[:text_color] = text_color || [100, 145, 170]
        config[:date_color] = date_color || [100, 145, 170]
        config[:unused_color] = unused_color || [200, 205, 215]
        config[:used_color] = used_color || [100, 145, 170]
        config[:font] = font || 'Hiragino Sans GB'
      end
    end
  end

end