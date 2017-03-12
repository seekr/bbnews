class NewsapiSource < Source
  def initialize
    @title = 'News API'
    @url = 'https://newsapi.org/'

    @source_title = @title
    @source_url = @url
  end

  # https://newsapi.org/
  def request(args, options={})
    limit = (1..50).include?(options[:limit]) ? options[:limit] : 10

    sorts = {
      :new => :latest,
      :hot => :popular,
      :top => :top
    }
    sort = sorts[options[:sort]] || :top

    params = {
      source: args[1],
      sortBy: sort,
      apiKey: ENV['NEWSAPI_KEY']
    }
    url = 'https://newsapi.org/v1/articles'
    res = RestClient.get(url, :params => params)
    json = JSON.parse(res.body)
    items = json['articles'].take(limit)

    items.map do |item|
      NewsapiItem.from_hash(item)
    end
  rescue RestClient::NotFound
  end
end
