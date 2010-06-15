require File.expand_path(File.dirname(__FILE__) + "/../test_helper.rb")

class PostTest < ActiveSupport::TestCase

  should have_db_column(:title).of_type(:string)
  should have_db_column(:permalink).of_type(:string)

  should have_db_column(:user_id).of_type(:integer)

  should_have_timestamps

  context "a post" do
    setup do
      @post = Factory.create(:post)
    end

    should_be_paranoid
    should_validate_presence_of :user
    should_belong_to :user
  end
end
