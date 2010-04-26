class AddFeedUrlToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :feed_url, :text
  end

  def self.down
    remove_column :posts, :feed_url
  end
end
