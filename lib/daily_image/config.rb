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

    # 外层边框偏移量
    attr_accessor :out_frame_offset

    # 下半部分内层边框偏移量
    attr_accessor :in_frame_offset

    def configuration
      @config ||= {}.tap do |config|
        config[:bg_color] = bg_color || [255, 255, 255]
        config[:frame_color] = frame_color || [100, 145, 170]
        config[:text_color] = text_color || [100, 145, 170]
        config[:date_color] = date_color || [100, 145, 170]
        config[:unused_color] = unused_color || [200, 205, 215]
        config[:used_color] = used_color || [100, 145, 170]
        config[:out_frame_offset] = out_frame_offset || 15
        config[:in_frame_offset] = in_frame_offset || 50
        config[:font] = font || 'Hiragino Sans GB'
      end
    end
  end

end