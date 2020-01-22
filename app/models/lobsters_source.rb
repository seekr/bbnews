class LobstersSource < Source
  def initialize
    @title = 'Lobsters'
    @url = 'https://lobste.rs'

    @source_title = @title
    @source_url = @url
    @filters = {
      limits: 1..24
    }
  end

  def request(args, options={})
    limit = @filters[:limits].include?(options[:limit]) ? options[:limit] : 10

    sorts = {
      :new => :latest,
      :hot => :popular,
      :top => :top
    }
    sort = sorts[options[:sort]] || :top

    params = {
      sources: args[1],
      sortBy: sort,
    }
    url = 'https://lobste.rs/hottest.json'
    res = RestClient.get(url, :params => params, :verify_ssl => false)
    json = JSON.parse(res.body)
    items = json

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
