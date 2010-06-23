require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Authlogic::TestCase

  def setup
    @post = Factory.create(:blog)
  end
  
  should route( :get, '/posts').to(        :action => :index,   :controller => :posts)
  should route( :get, '/posts/new').to(    :action => :new)
  should route( :post, '/posts').to(       :action => :create)
  should route( :get, '/posts/1').to(      :action => :show,    :id => 1)
  should route( :get, '/posts/1/edit').to( :action => :edit,    :id => 1)
  should route( :put, '/posts/1').to(      :action => :update,  :id => 1)
  should route( :delete, '/posts/1').to(   :action => :destroy, :id => 1)

  context "not logged in" do
    
    context "on GET to :show for first record" do
      setup do
       get :show, :id => @post.id
      end

      should assign_to :post
      should respond_with :success
      should render_template :show
      should_not set_the_flash
    end

    context "on GET to :new" do
      setup do
        get :new
      end

      should_be_denied_access
    end

    context "on GET to :index" do
      setup do
        get :index
      end

      should assign_to :posts
      should respond_with :success
      should render_template :index
      should_not set_the_flash
    end

    context "on POST to :create" do
      setup do
        @old_count = Post.count
        post :create, :post => Factory.attributes_for(:blog, :title => 'Testing')
      end

      should "not create a new post" do
        assert_equal @old_count, Post.count
      end

      should_be_denied_access
    end

    context "on GET to :edit for first record" do
      setup do
       get :edit, :id => @post.id
      end

      should_be_denied_access
    end

    context "on PUT to :update" do
      setup do
        put :update, :id => @post.id, :post => Factory.attributes_for(:blog, :title => 'Testing')
      end

      should_be_denied_access
    end

    context "on DELETE to :destroy" do
      setup do
        @old_count = Post.count
        delete :destroy, :id => @post.id
      end

      should "not destroy post" do
        assert_equal @old_count, Post.count
      end

      should_be_denied_access
    end
  end

  context "logged in" do
    setup do
      activate_authlogic
      UserSession.create(Factory.create(:user))
    end

    context "on GET to :show for first record" do
      setup do
       get :show, :id => @post.id
      end

      should assign_to :post
      should respond_with :success
      should render_template :show
      should_not set_the_flash
    end

    context "on GET to :new" do
      setup do
        get :new
      end

      should assign_to :post
      should respond_with :success
      should render_template :new
      should_not set_the_flash
    end

    context "on GET to :index" do
      setup do
        get :index
      end

      should assign_to :posts
      should respond_with :success
      should render_template :index
      should_not set_the_flash
    end

    context "on POST to :create" do
      setup do
        @old_count = Post.count
        post :create, :blog => Factory.attributes_for(:blog, :title => 'Testing')
      end

      should "create a new post" do
        assert_equal "", assigns(:post).errors.full_messages.join(', ')
        assert_equal @old_count + 1, Post.count
      end

      should assign_to :post
      should set_the_flash.to(/successful/i)
      should redirect_to('the created post') { post_url('testing')}
    end

    context "on GET to :edit for first record" do
      setup do
       get :edit, :id => @post.id
      end

      should assign_to :post
      should respond_with :success
      should render_template :edit
      should_not set_the_flash
    end

    context "on PUT to :update" do
      setup do
        put :update, :id => @post.id, :post => {}
      end

      should assign_to :post
      should set_the_flash.to(/successful/i)
      should redirect_to('the updated post') { post_url(@post)}
    end

    context "on DELETE to :destroy" do
      setup do
        @old_count = Post.count
        delete :destroy, :id => @post.id
      end

      should "destroy post" do
        assert_equal @old_count - 1, Post.count
      end

      should set_the_flash.to(/destroyed/i)
      should redirect_to('list of posts') { posts_url }
    end
  end
end
