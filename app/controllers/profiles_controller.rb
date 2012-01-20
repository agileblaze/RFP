class ProfilesController < ApplicationController
  before_filter :find_profile
  before_filter :lay,:only => [:edit,:show]
  before_filter :check_owner_access, :only => [:edit, :update]
  before_filter :require_login
  def require_login
    if session[:id]==nil
      #redirect_back_or_default(root_path)
      redirect_to  login_url
    end
  end
  def lay
    @user = User.find(params[:id])
    if @user.role_id==1
      render :layout=>"admin"
    else if @user.role_id==2
        render :layout=>"bdteam"
      else if @user.role_id==3|| @user.role_id==4
          render :layout=>"manager"
        end
      end
    end
  end
  def show
  end
  
  def edit
  end
  
  def update    
    unless @profile.nil?
      @profile.update_attributes(params[:profile])
      flash[:notice] = "Your profile has been succesfully updated."
      redirect_to profile_url(@profile.user)
    else
      render :edit
    end
  end
  
  protected
  
  def find_profile
    begin
      @user = User.find(params[:id])
    rescue
      @user = nil
    end
    @profile = @user.nil? ? nil : @user.profile
  end    
  
  def check_owner_access
    redirect_to profile_url(params[:id]) if logged_in? && current_user != @user
  end
end
