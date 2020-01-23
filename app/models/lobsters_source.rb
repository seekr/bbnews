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
    items = JSON.parse(res.body)
    

    items.map do |item|
      LobstersItem.from_hash(item)
    end
  rescue RestClient::NotFound
  end

end
