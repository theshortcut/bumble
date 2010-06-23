class CommentsController < InheritedResources::Base
  before_filter :require_user, :only => [:edit, :update, :destroy]

  belongs_to :post, :finder => :find_by_permalink_or_id, :optional => true

  respond_to :html, :js
  respond_to :atom, :only => :index

  def index
    index! do |format|
      format.html { redirect_to post_path(parent, :anchor => 'comments') }
      format.js { render collection }
    end
  end

  def show
    show! do |format|
      format.html { redirect_to post_path(parent, :anchor => dom_id(resource)) }
    end
  end

  def destroy
    destroy! do |format|
      format.html { redirect_to post_path(parent, :anchor => 'comments') }
      format.js { render :nothing => true }
    end
  end

  def update
    update! { post_path(parent, :anchor => dom_id(resource)) }
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.post = Post.find_by_permalink_or_id(params[:post_id])
    @comment.user = current_user
    create! do |success, failure|
      success.html { redirect_to post_path(parent, :anchor => dom_id(resource)) }
      success.js { render resource }
      failure.js { render :text => resource.errors.full_messages.join(', ').capitalize, :status => 403 }
    end
  end

end
