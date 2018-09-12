require "test_helper"

class DailyImage::PoemTest < Minitest::Test

  def test_it_should_get_poem_txt
    flag, res = ::DailyImage::Poem.new.txt

    assert flag
    assert_kind_of Hash, res
  end

end
