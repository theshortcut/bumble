class PostsController < InheritedResources::Base
  before_filter :require_user, :except => [:index, :show, :search]

  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    create! do |format|
      if params[:commit] == 'Preview'
        @post.valid?
        format.js { render :partial => 'preview', :locals => {:post => @post} }
        format.html { redirect_to posts_path }
      else
        if @post.save
          format.js { render :partial => 'post', :locals => {:post => @post} }
          format.html { redirect_to post_path(@post) }
        else
          format.js { render :text => @post.errors.full_messages.join(', ').capitalize, :status => 403 }
          format.html { render :action => 'new' }
        end
      end
    end
  end

  def search
    @posts = current_model.search(params[:query], :page => params[:page],
                                                  :order => 'published_at DESC',
                                                  :per_page => per_page)
    respond_to do |format|
      format.html
      format.atom { render :action => :index}
    end
  end

  protected

    def collection
      @posts ||= end_of_association_chain.paginate( :page => params[:page],
                                                    :order => 'published_at DESC',
                                                    :per_page => (iphone? ? 5 : 10),
                                                    :include => :comments)
    end

    def resource
      @post ||= end_of_association_chain.find_by_permalink_or_id(params[:id])
    end
end
