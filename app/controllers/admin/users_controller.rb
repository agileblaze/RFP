class Admin::UsersController < ApplicationController
  require_role :admin
  layout 'admin'
  before_filter :require_login, :only => [:suspend]

  def require_login
    if session[:id]==nil
      #redirect_back_or_default(root_path)
      redirect_to :controller => 'sessions', :action => 'new'
    end
  end


  %w(email login role_id).each do |attr|
    in_place_edit_for :user, attr.to_sym
  end
  
  def reset_password
    @user = User.find(params[:id])
    @user.reset_password!
    
    flash[:notice] = "A new password has been sent to the user by email."
    redirect_to admin_user_path(@user)
  end
  
  def pending
    @users = User.paginate :all, :conditions => {:state => 'pending'}, :page => params[:page]
    render :action => 'index'
  end
  
  def suspended
    @users = User.paginate :all, :conditions => {:state => 'suspended'}, :page => params[:page]
    render :action => 'index'
  end
  
  def active
    @users = User.paginate :all, :conditions => {:state => 'active'}, :page => params[:page]
    render :action => 'index'
  end
  
  def deleted
    @users = User.paginate :all, :conditions => {:state => 'deleted'}, :page => params[:page]
    render :action => 'index'
  end
  
  def activate
    @user = User.find(params[:id])
    @user.activate!
    redirect_to admin_users_path
  end
  
  def suspend
    @user = User.find(params[:id])
    @user.suspend! 
    redirect_to admin_users_path
  end

  def unsuspend
    @user = User.find(params[:id])
    @user.update_attributes(:state=>"active")
    redirect_to admin_users_path
  end

  def purge
    @user = User.find(params[:id])
    @project=Project.find(:all,:conditions=>["created_by=?",params[:id]])
    @project.each do |project|
      project.update_attributes(:created_by=>'',:assigned_by=>'')
    end
     @project=Project.find(:all,:conditions=>["assigned_by=?",params[:id]])
     @project.each do |project|
      project.update_attributes(:assigned_by=>'')
     end
     @project=Project.find(:all,:conditions=>["assigned_to=?",params[:id]])
      @project.each do |project|
      project.update_attributes(:assigned_to=>'')
     end
    @user.destroy
    redirect_to admin_users_url
  end
  
  # DELETE /admin_users/1
  # DELETE /admin_users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.delete!

    redirect_to admin_users_path
  end

  # GET /admin_users
  # GET /admin_users.xml
  def index
    @users = User.paginate :all, :page => params[:page]
   # respond_to do |format|
    #  format.html # index.html.erb
     # format.xml  { render :xml => @users }
    #end
  end

  # GET /admin_users/1
  # GET /admin_users/1.xml
  def show
    @user = User.find(params[:id])
    @roles = Role.find(:all)
   # @roles = Role.find(:all)
    #@count=RolesUser.count(:conditions=>["user_id=?",params[:id]])
    #@role=RolesUser.find(:first,:conditions=>["user_id=?",params[:id]])
     #render :text=>role.role.name
   #respond_to do |format|
   # format.html # show.html.erb
   #   format.xml  { render :xml => @user }
   # end
  end

  # GET /admin_users/new
  # GET /admin_users/new.xml
  def new
    @user = User.new

    #respond_to do |format|
     # format.html # new.html.erb
     # format.xml  { render :xml => @user }
   # end
  end
  
  # POST /admin/users
  def create_new
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        @user.update_attributes(:state=>"pending")
        @roles_user=RolesUser.new
        @roles_user.update_attributes(:user_id=>@user.id,:role_id=>@user.role_id)
        flash[:notice] = "User was successfully created."
        #UserMailer.mails('cshamith@sparksupport.com')
        format.html { redirect_to(admin_user_url(@user)) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        #render :text=>params[:user][:role_id] and return
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

   def set_user_role_name
    @user = User.find_by_id(params[:id])
    @role_user = RolesUser.find_by_user_id(params[:id])
    if(@user)
      @user.update_attribute('role_id',params['value'])
      @role_name = Role.find_by_id(@user.role_id)
        if (@role_user)
                @role_user.update_attribute('role_id',params['value'])
        end
      render :text => @role_name.name
    else
      render :text => 'Error updating Role!'
    end
  end
	
end
