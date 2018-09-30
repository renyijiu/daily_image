require "test_helper"

class DailyImageTest < Minitest::Test

  def test_should_has_version
    refute_nil ::DailyImage::VERSION
  end

  def test_should_get_config
    config = DailyImage.config

    assert config[:bg_color]
    assert config[:frame_color]
    assert config[:text_color]
    assert config[:date_color]
    assert config[:unused_color]
    assert config[:used_color]
    assert config[:font]
    assert config[:out_frame_offset]
    assert config[:in_frame_offset]
  end

  def test_should_set_config
    Singleton.__init__(DailyImage::Config)
    color = [rand(0..255), rand(0..255), rand(0..255)]

    DailyImage.configure do |config|
      config.bg_color = color
    end

    config = DailyImage.config
    assert_equal color, config[:bg_color]
  end

  def test_should_generate_image
    filename = "daily_#{Date.today}.jpeg"
    file_path = File.join('./tmp/', filename)

    DailyImage.draw_image('./tmp/')

    assert File.file?(file_path)
    File.delete(file_path)
  end

  def test_should_generate_image_when_set_date
    (0..10).each do |i|
      date = Date.today - i

      filename = "daily_#{date}.jpeg"
      file_path = File.join('./tmp/', filename)

      DailyImage.draw_image('./tmp/', date)

      assert File.file?(file_path)
      File.delete(file_path)
    end
  end
end
