require 'feedzirra'

class FeedUpdater 
  
  def self.update

    Feed.all.each do |feed|
      channel = Feedzirra::Feed.fetch_and_parse(feed.feed_url)
      changed = false
      channel.entries.each do |item|
        if item.published > feed.updated_at
          # This is a new item.
          post = if item.url.nil?
                   Blog.new(:published_at => item.published, :publicly_viewable => true, :via => feed.link_url, :user => feed.user)
                 else
                   Link.new(:link_url => item.url, :published_at => item.published, :publicly_viewable => true, :via => feed.link_url, :user => feed.user)
                 end
          post.title = if !item.title.nil?
                         item.title.strip
                       elsif !channel.title.nil?
                         channel.title.strip
                       else
                     "Unknown title"
                       end
          post.body = if !item.summary.nil?
                        item.summary.strip
                      elsif !item.content.nil?
                        item.content.strip
                      end
          if !post.save
            raise post.errors.full_messages.to_yaml
          end
          changed = true
        end
      end
      if changed
        feed.updated_at = Time.now
        feed.save
      end
    end

  end
end
