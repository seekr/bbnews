class LobstersItem < Item
  def self.from_hash(hash)
    self.new(
      author: hash['username'] || hash['submitter_user'],
      created_at: Time.at(hash['created_at']),
      title: hash['title'],
      url: hash['title'],
      counts: Counts.new(
        points: hash['upvotes'],
        comments: hash['comment_count'] || hash['num_comments']
      )
    )
  end
end
