class NewsapiSource < Source
  def initialize
    @title = 'News API'
    @url = 'https://newsapi.org/'

    @source_title = @title
    @source_url = @url
    @filters = {
      limits: 1..50
    }
  end

  # https://newsapi.org/
  def request(args, options={})
    limit = @filters[:limits].include?(options[:limit]) ? options[:limit] : 10

    params = {
      sources: args[1],
      apiKey: ENV['NEWSAPI_KEY']
    }

    url = 'https://newsapi.org/v2/top-headlines'
    res = RestClient.get(url, :params => params, :verify_ssl => false)
    json = JSON.parse(res.body)
    items = json['articles'].take(limit)

    items.map do |item|
      NewsapiItem.from_hash(item)
    end
  rescue RestClient::NotFound
  end

  def get_suggestions(query)
    # Only one source per query
    return [] if query.split(' ', -1).keep_if { |w| !w[':']}.count > 2

    Rails.cache.fetch('newsapi:suggestions', expires_in: 1.day) do
      url = 'https://newsapi.org/v2/sources'
      res = RestClient.get(url, apiKey: ENV['NEWSAPI_KEY'], :verify_ssl => false)
      json = JSON.parse(res.body)
      json['sources'].map { |source| source['id'] }
    end
  end
end
