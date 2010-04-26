class Feed < Post
  validates_presence_of :feed_url

  def feed_url=(x)
    write_attribute(:feed_url, x.gsub(/^feed:\/\//, 'http://'))
  end

end
