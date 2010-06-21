class UserSessionsController < InheritedResources::Base
  def create
    create! { root_path }
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = 'Logged out successfully'
    redirect_to root_path
  end
end
