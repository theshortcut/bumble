require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_db_column(:email).of_type(:string).with_options(:null => false)
  should have_db_column(:crypted_password).of_type(:string).with_options(:null => false)
  should have_db_column(:password_salt).of_type(:string).with_options(:null => false)
  should have_db_column(:persistence_token).of_type(:string).with_options(:null => false)

  should have_db_column(:current_login_ip).of_type(:string)
  should have_db_column(:last_login_ip).of_type(:string)
  should have_db_column(:first_name).of_type(:string)
  should have_db_column(:last_name).of_type(:string)
  should have_db_column(:perishable_token).of_type(:string)

  should have_db_column(:login_count).of_type(:integer).with_options(:default => 0)
  should have_db_column(:failed_login_count).of_type(:integer).with_options(:default => 0)

  should have_db_column(:last_request_at).of_type(:datetime)
  should have_db_column(:current_login_at).of_type(:datetime)
  should have_db_column(:last_login_at).of_type(:datetime)
  should have_db_column(:activated_at).of_type(:datetime)

  should_have_timestamps

  context "a user" do
    setup do
      @user = Factory.create(:user)
    end

    # should_be_paranoid
    should validate_presence_of :first_name

    should "update activated_at when activated" do
      @user.activate!
      assert @user.activated_at
    end
  end
  
  context "a new user" do
    setup do
      @user = Factory.create(:user)
    end

    should "not be activated" do
      assert_equal @user.activated_at, nil
    end
  end
  
end
