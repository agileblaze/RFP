class Rfp::RfpAdminController < ApplicationController
   require_role :admin
  layout 'admin'

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
       @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.created_by ORDER BY users.login")
    else if params['sort']=='created_by_reverse'
        @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.created_by ORDER BY users.login DESC")
    else if params['sort']=='assigned_to'
          @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.assigned_to ORDER BY users.login")
    else if params['sort']=='assigned_to_reverse'
          @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.assigned_to ORDER BY users.login DESC")
    else if  params['sort']=='assigned_by'
          @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.assigned_by ORDER BY users.login")
    else if  params['sort']=='assigned_by_reverse'
          @doc=Project.find_by_sql("select * from projects LEFT OUTER JOIN users ON users.id=projects.assigned_by ORDER BY users.login DESC")
    else
          @doc=Project.find(:all,:order=>sort)
    end
    end
    end
    end
    end
    end
    # @doc=Rfp.find(:all)
  end
 def view_rfp
    @project=Project.find(params[:id])
    #id=params[:id]
    @doc=Rfp.find(:all,:conditions=>["project_id=?",params[:id]])
    @doc_rel=RfpDocument.find(:all,:conditions=>["project_id=?",params[:id]])
    #render :text=>@doc.project_description[0,100] and return
    render :partial=>"view_rfp"
  end
  def remove_rfp
     #render :text=>params[:id] and return
     Project.delete_all(:id=>params[:id])
     Rfp.delete_all(:project_id=>params[:id])
     RfpDocument.delete_all(:project_id=>params[:id])
    redirect_to :action=>"index"
  end
end
