require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Authlogic::TestCase

  def setup
    @comment = Factory.create(:comment)
  end
  
  should route( :get, '/posts/1/comments').to(        :action => :index,   :post_id => 1,
                                                      :controller => :comments)
  should route( :get, '/posts/1/comments/new').to(    :action => :new,     :post_id => 1)
  should route( :post, '/posts/1/comments').to(       :action => :create,  :post_id => 1)
  should route( :get, '/posts/1/comments/1').to(      :action => :show,    :post_id => 1, :id => 1)
  should route( :get, '/posts/1/comments/1/edit').to( :action => :edit,    :post_id => 1, :id => 1)
  should route( :put, '/posts/1/comments/1').to(      :action => :update,  :post_id => 1, :id => 1)
  should route( :delete, '/posts/1/comments/1').to(   :action => :destroy, :post_id => 1, :id => 1)

  context "logged in" do
    setup do
      activate_authlogic
      UserSession.create(Factory.create(:user))
    end

    context "on GET to :show for first record" do
      setup do
       get :show, :id => @comment.id, :post_id => @comment.post.id
      end

      should redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => dom_id(@comment))}
      should_not set_the_flash
    end

    context "on GET to :new" do
      setup do
        get :new, :post_id => @comment.post.id
      end

      should assign_to :comment
      should respond_with :success
      should render_template :new
      should_not set_the_flash
    end

    context "on GET to :index" do
      setup do
       get :index, :post_id => @comment.post.to_param
      end

      should redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => 'comments')}
      should_not set_the_flash
    end

    context "on POST to :create" do
      setup do
        @old_count = Comment.count
        post :create, :comment => Factory.attributes_for(:comment), :post_id => @comment.post.id
      end

      should "create a new comment" do
        assert_equal @old_count + 1, Comment.count
        assert assigns[:comment].valid?
      end

      should assign_to :comment
      should set_the_flash.to(/successful/i)
      should redirect_to('the comments post') { post_url(assigns(:comment).post.to_param, :anchor => dom_id(assigns(:comment)))}
    end

    context "on GET to :edit for first record" do
      setup do
       get :edit, :id => @comment.id, :post_id => @comment.post.id
      end

      should assign_to :comment
      should respond_with :success
      should render_template :edit
      should_not set_the_flash
    end

    context "on PUT to :update" do
      setup do
        put :update, :id => @comment.id, :post_id => @comment.post.id, :comment => {}
      end

      should assign_to :comment
      should set_the_flash.to(/successful/i)
      should redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => dom_id(@comment))}
    end

    context "on DELETE to :destroy" do
      setup do
        @old_count = Comment.count
        delete :destroy, :id => @comment.id, :post_id => @comment.post.id
      end

      should "destroy comment" do
        assert_equal @old_count - 1, Comment.count
      end

      should set_the_flash.to(/destroyed/i)
      should redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => 'comments')}
    end
  end
  
  context "not logged in" do
    context "on GET to :show for first record" do
      setup do
       get :show, :id => @comment.id, :post_id => @comment.post.id
      end

      should redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => dom_id(@comment))}
      should_not set_the_flash
    end

    context "on GET to :new" do
      setup do
        get :new, :post_id => @comment.post.id
      end

      should assign_to :comment
      should respond_with :success
      should render_template :new
      should_not set_the_flash
    end

    context "on GET to :index" do
      setup do
       get :index, :post_id => @comment.post.id
      end

      should redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => 'comments')}
      should_not set_the_flash
    end

    context "on POST to :create" do
      setup do
        @old_count = Comment.count
        post :create, :comment => Factory.attributes_for(:comment, :author_name => 'David', :author_email => 'dave@example.com'), :post_id => @comment.post.id
      end

      should "create a new comment" do
        assert_equal @old_count + 1, Comment.count
      end

      should assign_to :comment
      should set_the_flash.to(/successful/i)
      should redirect_to('the comments post') { post_url(@comment.post.to_param, :anchor => dom_id(assigns(:comment)))}
    end

    context "on GET to :edit for first record" do
      setup do
       get :edit, :id => @comment.id, :post_id => @comment.post.id
      end

      should_be_denied_access
    end

    context "on PUT to :update" do
      setup do
        put :update, :id => @comment.id, :post_id => @comment.post.id, :comment => {}
      end

      should_be_denied_access
    end

    context "on DELETE to :destroy" do
      setup do
        @old_count = Comment.count
        delete :destroy, :id => @comment.id, :post_id => @comment.post.id
      end

      should "not destroy comment" do
        assert_equal @old_count, Comment.count
      end

      should_be_denied_access
    end
  end
end
