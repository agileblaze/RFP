class Rfp::RfpManagerController < ApplicationController
  layout 'manager'
  before_filter :require_login

    def require_login
    if session[:id]==nil
      #redirect_back_or_default(root_path)
      redirect_to  login_url
    else
      user_role=User.find(session[:id])
      if user_role.role_id!=3 and user_role.role_id!=4
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
    when "assigned_by" then "assigned_by"
    when "project_name_reverse"  then "project_name DESC"
    when "deadline_reverse"   then "deadline DESC"
    when "created_by_reverse" then "created_by DESC"
    when "assigned_to_reverse" then "assigned_to DESC"
    when "assigned_by_reverse" then "assigned_by DESC"
    end
    if params['sort']=='created_by'
      @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.created_by where projects.assigned_to=#{current_user.id} ORDER BY users.login")
    else if params['sort']=='created_by_reverse'
        @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.created_by where projects.assigned_to=#{current_user.id} ORDER BY users.login DESC")
      else if  params['sort']=='assigned_by'
          @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.assigned_by where projects.assigned_to=#{current_user.id} ORDER BY users.login")
        else if  params['sort']=='assigned_by_reverse'
            @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.assigned_by where projects.assigned_to=#{current_user.id} ORDER BY users.login DESC")
          else
            @doc=Project.find(:all,:conditions=>["assigned_to=?",current_user.id],:order=>sort)
          end
        end
      end
    end
    #@doc=Rfp.find(:all,:conditions=>["assigned_to=?",current_user.id])
  end
  def view_rfp
    #id=params[:id]
    @project=Project.find(params[:id])
    @doc=Rfp.find(:all,:conditions=>["project_id=?",params[:id]])
    @doc_rel=RfpDocument.find(:all,:conditions=>["project_id=?",params[:id]])
    #render :text=>@doc.project_description[0,100] and return
    render :partial=>"view_rfp"
  end
  def upload_docs
    @project=Project.find(params[:id])
    @rfp_document=RfpDocument.new
    render :partial=>"upload_docs"
  end
  def save_a
    @rfp_document=RfpDocument.new(params[:rfp_document])
     @project=Project.find(params[:id])
      if params[:type]==nil
      flash[:notice] = "Data not saved....#Select type of file"
      redirect_to :action=>"index"
    else if  @rfp_document.save
        @project.update_attributes(:rfp_doc_uploaded=>'yes')
        if params[:type]=="srs"
          #   @rfp_document.save
          name=@project.project_name+'_'+params[:type]+'_'+@rfp_document.filename
          @rfp_document.update_attributes(:filename=>name)
          @rfp_document.update_attributes(:project_id=>params[:id],:uploded_by=>current_user.id,:status=>params[:type])
          redirect_to :action=>"index"
          # render :text=>params[:id] and return
        else if params[:type]=="est"
            #  @rfp_document.save
            name=@project.project_name+'_'+params[:type]+'_'+@rfp_document.filename
            @rfp_document.update_attributes(:filename=>name)
            @rfp_document.update_attributes(:project_id=>params[:id],:uploded_by=>current_user.id,:status=>params[:type])
            redirect_to :action=>"index"
            # render :text=>params[:id] and return
          else if params[:type]=="other"
              # @rfp_document.save
              name=@project.project_name+'_'+params[:type]+'_'+@rfp_document.filename
              @rfp_document.update_attributes(:filename=>name)
              @rfp_document.update_attributes(:project_id=>params[:id],:uploded_by=>current_user.id,:status=>params[:type])
              redirect_to :action=>"index"
              # render :text=>params[:id] and return
            end
          end
        end
      else
        sort = case params['sort']
        when "project_name"  then "project_name"
        when "deadline"   then "deadline"
        when "created_by" then "created_by"
        when "assigned_to" then "assigned_to"
        when "assigned_by" then "assigned_by"
        when "project_name_reverse"  then "project_name DESC"
        when "deadline_reverse"   then "deadline DESC"
        when "created_by_reverse" then "created_by DESC"
        when "assigned_to_reverse" then "assigned_to DESC"
        when "assigned_by_reverse" then "assigned_by DESC"
        end
    if params['sort']=='created_by'
      @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.created_by where projects.assigned_to=#{current_user.id} ORDER BY users.login")
    else if params['sort']=='created_by_reverse'
        @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.created_by where projects.assigned_to=#{current_user.id} ORDER BY users.login DESC")
      else if  params['sort']=='assigned_by'
          @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.assigned_by where projects.assigned_to=#{current_user.id} ORDER BY users.login")
        else if  params['sort']=='assigned_by_reverse'
            @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.assigned_by where projects.assigned_to=#{current_user.id} ORDER BY users.login DESC")
          else
            #@doc=Rfp.find(:all,:order=>sort)
            @doc=Project.find(:all,:conditions=>["assigned_to=?",current_user.id],:order=>sort)
          end
        end
      end
    end
        render :action=>"index"
      end
    end
  end
end
