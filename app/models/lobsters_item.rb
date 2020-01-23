class LobstersItem < Item
  def self.from_hash(hash)
    time = hash['created_at'] ? Time.parse(hash['created_at']) : nil

    self.new(
      author: hash['submitter_user']['username'],
      created_at: time,
      title: hash['title'],
      url: hash['url'],
      via: hash['comments_url'],
      counts: Counts.new(
        points: hash['upvotes'],
        comments: hash['comment_count'] || hash['num_comments']
      )
    )
  end
end
