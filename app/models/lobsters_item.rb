class LobstersItem < Item
  def self.from_hash(hash)
    via = "https://lobste.rs/s/#{hash['id'].json || hash['objectID']}"
    url = hash['url'].nil? || hash['url'].start_with?('item?id=') ? via : hash['url']

    self.new(
      author: hash['user'] || hash['author'],
      created_at: Time.at(hash['time'] || hash['created_at_i']),
      title: hash['title'],
      url: url,
      via: via,
      counts: Counts.new(
        points: hash['points'],
        comments: hash['comments_count'] || hash['num_comments']
      )
    )
  end
end
