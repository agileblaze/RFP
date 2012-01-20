class Rfp::RfpBdteamController < ApplicationController
  layout 'bdteam'
  before_filter :require_login
    def require_login
    if session[:id]==nil
      #redirect_back_or_default(root_path)
      redirect_to  login_url
    else
      user_role=User.find(session[:id])
      if user_role.role_id!=2
        redirect_to  login_url
      end
    end
  end
  def index
     sort = case params['sort']
             when "project_name"  then "project_name"
             when "deadline"   then "deadline"
             when "created_by" then "created_by"
             when "assigned_to" then "assigned_to"
             when "project_name_reverse"  then "project_name DESC"
             when "deadline_reverse"   then "deadline DESC"
             when "created_by_reverse" then "created_by DESC"
             when "assigned_to_reverse" then "assigned_to DESC"
            end
    if params['sort']=='created_by'
       @doc=Rfp.find_by_sql("select projects.id,projects.project_name,projects.assigned_to,projects.assigned_by,projects.created_by,projects.deadline from projects LEFT OUTER JOIN users ON users.id=projects.created_by ORDER BY users.login")
        # @doc=Project.find(:all)
    else if params['sort']=='created_by_reverse'
        @doc=Rfp.find_by_sql("select  projects.id,projects.project_name,projects.assigned_to,projects.assigned_by,projects.created_by,projects.deadline from projects LEFT OUTER JOIN users ON users.id=projects.created_by ORDER BY users.login DESC")
    else if params['sort']=='assigned_to'
          @doc=Rfp.find_by_sql("select  projects.id,projects.project_name,projects.assigned_to,projects.assigned_by,projects.created_by,projects.deadline from projects LEFT OUTER JOIN users ON users.id=projects.assigned_to ORDER BY users.login")
    else if params['sort']=='assigned_to_reverse'
          @doc=Rfp.find_by_sql("select  projects.id,projects.project_name,projects.assigned_to,projects.assigned_by,projects.created_by,projects.deadline from projects LEFT OUTER JOIN users ON users.id=projects.assigned_to ORDER BY users.login DESC")
    else if params['sort']=='project_name'
         @doc=Project.find(:all,:order=>"project_name")
    else if params['sort']=='project_name_reverse'
         @doc=Project.find(:all,:order=>"project_name DESC")
    else if params['sort']=='deadline'
         @doc=Project.find(:all,:order=>"deadline")
    else if params['sort']=='deadline_reverse'
         @doc=Project.find(:all,:order=>"deadline DESC")
    else
      @doc=Project.find(:all,:order=>sort)
    end
    end
    end
    end
    end
    end
    end
    end
  end
  def save_a
     @rfp= Rfp.new(params[:rfp])
     @project=Project.new(params[:project])
     if @rfp.save
       if @project.save
          @rfp.update_attributes(:project_id=>@project.id)
          new_filename=@project.project_name+'_RFP_'+@rfp.filename
          @rfp.update_attributes(:filename=>new_filename,:created_by=>current_user.id)
          @project.update_attributes(:created_by=>current_user.id)
          if params[:project][:assigned_to]!=''
           @project.update_attributes(:assigned_by=>current_user.id)
           user=User.find(:first,:conditions=>["id=?",params[:project][:assigned_to]])
           user1=User.find(:first,:conditions=>["id=?",@project.assigned_by])
           project=@project
           rfp=@rfp
           UserMailer.deliver_assign_rfp(user,user1,project,rfp)
          end
          redirect_to :action=>"index"
        end
     else
      render :action=>"upload"
     end
  end
  def upload
     @rfp=Rfp.new
     @project= Project.new
  end
  def all_doc
    @project=Project.find(params[:id])
    @doc=Rfp.find(:all,:conditions=>["project_id=?",params[:id]])
    @doc_rel=RfpDocument.find(:all,:conditions=>["project_id=?",params[:id]])
    render :partial=>"all_doc"
  end
  def manage_rfp
     @doc=Project.all(:conditions=>["created_by=?",current_user.id])
  end
  def modify
    @rfp=Project.find(params[:id])
    render :partial=>"modify"
  end
  def update_rfp
    @rfp=Rfp.find(params[:id])
    @rfp.update_attributes(params[:rfp])
     if params[:rfp][:assigned_to]!=''
       @rfp.update_attributes(:assigned_by=>current_user.id)

       user=User.find(:first,:conditions=>["id=?",params[:rfp][:assigned_to]])
       user1=User.find(:first,:conditions=>["id=?",@rfp.assigned_by])
       rfp=@rfp
       UserMailer.deliver_assign_rfp(user,user1,rfp)
     end

     if @rfp.assigned_to==nil
       @rfp.update_attributes(:assigned_by=>'')
     end
    redirect_to :action=>"index"
  end

  def update_project
     #render :text=>params[:id] and return
     @project=Project.find(params[:id])
     @project.update_attributes(params[:rfp])
     if params[:rfp][:assigned_to]!=''
       @project.update_attributes(:assigned_by=>current_user.id)
       @project.update_attributes(:created_by=>current_user.id)
       userto=User.find(:first,:conditions=>["id=?",params[:rfp][:assigned_to]])
       userby=User.find(:first,:conditions=>["id=?",@project.assigned_by])
       project=@project
       UserMailer.deliver_reassign_rfp(userto,userby,project)
     end
     redirect_to :action=>"index"
  end

  def upload_rfp
    #render :text=>params[:id] and return
    @project=Project.find(params[:id])
    @rfp=Rfp.new()
   render :partial=>"upload_rfp"
  end
  def add_rfp
    #render :text=>params[:id] and return
    @rfp=Rfp.new(params[:rfp])
    @rfp.save
    @rfp.update_attributes(:project_id=>params[:id],:created_by=>current_user.id)
    project=Project.find(params[:id])
    if project.assigned_to!=''
      userto=User.find(:first,:conditions=>["id=?",project.assigned_to])
      userby=User.find(:first,:conditions=>["id=?",project.assigned_by])
      rfp=@rfp
      UserMailer.deliver_add_rfp(userto,userby,project,rfp)
    end
   redirect_to :action=>"index"
  end
  def delete_rfp
   Rfp.delete_all(:id=>params[:id])
   redirect_to :action=>"manage_rfp"
  end
  def remove_docs
     @project=Project.find(params[:id])
     @doc=Rfp.find(:all,:conditions=>["project_id=?",params[:id]])
     @rfp_rel=RfpDocument.find(:all,:conditions=>["project_id=?",params[:id]])
     render :partial=>"remove_docs"
  end
  def remove_rel_rfp
    RfpDocument.delete_all(:id=>params[:id])
    count=RfpDocument.count(:conditions=>["project_id=?",params[:project_id]])
    if count ==0
      @project=Project.find(params[:project_id])
      @project.update_attributes(:rfp_doc_uploaded=>'no')
    end
    redirect_to :action=>"manage_rfp"
  end
  def remove_rfp
    Rfp.delete_all(:id=>params[:id])
    redirect_to :action=>"manage_rfp"
  end
end
