class UsersController < InheritedResources::Base
  before_filter :require_user, :except => [:activate]

  def create
    @user = User.new(params[:user])
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to login_path
    else
      render :action => :new
    end
  end

  def activate
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    if @user.activate!
      @user.deliver_activation_confirmation!
      flash[:notice] = "Your account has been activated."
      UserSession.create(@user)
      redirect_to root_path
    else
      render :action => :new
    end
  end

  protected

    def collection
      @users ||= end_of_association_chain.paginate( :page => params[:page] )
    end
end
