class PostsController < InheritedResources::Base
  before_filter :require_user, :except => [:index, :show, :search]

  respond_to :html, :js
  respond_to :atom, :only => :index

  def create
    Post.types.each do |t|
      if params.include?(t.downcase)
        @post = Object.const_get(t).new(params[t.downcase])
      end
    end
    @post ||= Blog.new
    @post.user = current_user
    if params[:commit] == "Preview"
      @post.valid?
      respond_to do |format|
        format.js { render :partial => 'preview', :locals => {:post => @post} }
        format.html do
          flash[:notice] = 'Create successful!'
          redirect_to posts_path
        end
      end
    else
      if @post.save
        respond_to do |format|
          format.js { render :partial => 'post', :locals => {:post => @post} }
          format.html do
            flash[:notice] = 'Create successful!'
            redirect_to post_path(@post)
          end
        end
      else
        respond_to do |format|
          format.js   { render :text => @post.errors.full_messages.join(', ').capitalize, :status => 403 }
          format.html { render :action => "new" }
        end
      end
    end
  end

  def destroy
    destroy! do |format|
      format.html { redirect_to posts_path }
      format.js { render :nothing => true }
    end
  end

  def search
    @posts = resource_class.search(params[:query], :page => params[:page],
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
