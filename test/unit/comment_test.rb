require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  should have_db_column(:body).of_type(:text)

  should have_db_column(:user_id).of_type(:integer)
  should have_db_column(:post_id).of_type(:integer)

  should_have_timestamps

  context "a comment" do
    setup do
      @comment = Factory.create(:comment)
    end

    # should_be_paranoid
    should validate_presence_of :body
    should belong_to :user
  end
end
