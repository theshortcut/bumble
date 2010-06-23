require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  def setup
    @user = Factory.create(:user)
  end
  
  should route( :get, '/password_resets/new').to(                 :action => :new,
                                                                  :controller => :password_resets)
  should route( :post, '/password_resets').to(                    :action => :create)
  should route( :get, '/password_resets/1234567abcdefg/edit').to( :action => :edit,   :id => '1234567abcdefg')
  should route( :put, '/password_resets/1234567abcdefg').to( :action => :update, :id => '1234567abcdefg')

  context "on GET to :new" do
    setup do
      get :new
    end

    should respond_with :success
    should render_template :new
    should_not set_the_flash
  end

  context "on POST to :create" do
    setup do
      post :create, :email => @user.email
    end

    should assign_to :user
    should set_the_flash.to('Instructions to reset your password have been emailed to you. Please check your email.')
    should redirect_to('the created password_reset') { root_url}
  end

  context "a user who has requested a password reset" do
    setup do
      @user = Factory.create(:user)
      @user.deliver_password_reset_instructions!
    end

    context "on GET to :edit for first record" do
      setup do
       get :edit, :id => @user.perishable_token
      end

      should assign_to :user
      should respond_with :success
      should render_template :edit
      should_not set_the_flash
    end

    context "on PUT to :update" do
      setup do
        put :update, :id => @user.perishable_token, :user => {}
      end

      should assign_to :user
      should set_the_flash.to('Password successfully updated')
      should redirect_to('the updated password_reset') { root_path}
    end
  end
end
