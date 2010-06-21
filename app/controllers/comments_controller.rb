class CommentsController < InheritedResources::Base
  before_filter :require_user, :only => [:edit, :update, :destroy]

  belongs_to :post, :finder => :find_by_permalink_or_id

  def index
    index! do |format|
      format.html { redirect_to post_path(parent, :anchor => 'comments') }
    end
  end

  def show
    show! do |format|
      format.html { redirect_to post_path(parent, :anchor => dom_id(resource)) }
    end
  end

  def destroy
    destroy! { post_path(parent, :anchor => 'comments') }
  end

  def update
    update! { post_path(parent, :anchor => dom_id(resource)) }
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    create! { post_path(@comment.post, :anchor => dom_id(@comment)) }
  end
end
