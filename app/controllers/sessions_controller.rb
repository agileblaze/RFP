# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  layout 'login'
  def new
  end

  def create
    logout_keeping_session!
      password_authentication
  end

  def destroy
    session[:id]=''
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_to :controller=>"dashboard",:action=>"index"
  end

  def open_id_authentication
    authenticate_with_open_id(params[:openid_url], :required => [:nickname, :email]) do |result, identity_url|
      if result.successful? && self.current_user = User.find_by_identity_url(identity_url)
        successful_login
      else
        flash[:error] = result.message || "Sorry no user with that identity URL exists"
        @rememer_me = params[:remember_me]
        render :action => :new
      end
    end
  end
  
  protected

  def password_authentication
    user = User.authenticate(params[:login], params[:password])
    if user
      self.current_user = user
      successful_login
    else
      note_failed_signin
      @login = params[:login]
      @remember_me = params[:remember_me]
      render :action => :new
    end
  end
  
  def successful_login
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    session[:id]=current_user.id
    if current_user.role_id==1
      redirect_to :controller=>"rfp/rfp_admin",:action=>"index"
    else if current_user.role_id==2
      redirect_to :controller=>"rfp/rfp_bdteam",:action=>"index"
    else if current_user.role_id==3 ||current_user.role_id==4
        redirect_to :controller=>"rfp/rfp_manager",:action=>"index"
    else
      a=1
     end
     end
    end
    flash[:notice] = "Logged in successfully"
  end

  def note_failed_signin
    if params[:login]=='' and params[:password]==''
      flash[:error] = "Enter User Name and password"
    else if params[:login]==''
      flash[:error] = "Enter User Name "
    else if params[:password]==''
      flash[:error] = "Enter User password "
    else
      flash[:error] = "Couldn't log you in as '#{params[:login]}'"
        end
      end
    end
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
