require "net/http"
require "json"

#
# 使用 一言·古诗词 API, 获取一条古诗词
#
# API返回结果：
# {
#    content: "陌上风光浓处。第一寒梅先吐。",
#    origin: "十样花·陌上风光浓处",
#    author: "李弥逊",
#    category: "古诗文-植物-梅花"
# }
#
module DailyImage
  class Poem

    API_URL = "https://api.gushi.ci/all.json"

    def txt
      get(API_URL)
    end

    private

    def get(url, params={})
      uri = URI(url)
      uri.query = URI.encode_www_form(params)

      res = Net::HTTP.get_response(uri)
      format_res(res)
    end

    def format_res(res)
      return [false, {}] unless res.is_a?(Net::HTTPSuccess)

      [true, JSON.parse(res.body)]
    end

  end
end