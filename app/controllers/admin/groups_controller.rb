class Admin::GroupsController < ApplicationController
  require_role :admin
  layout 'admin'
  def index
    @group= Role.all
  end
  def all_group
    @data=User.all
  end
  def admin_group
    @data=User.all(:conditions=>["role_id=?",1])
  end
  def bdteam_group
    @count=User.count(:conditions=>["role_id=?",2])
    @data=User.all(:conditions=>["role_id=?",2])
  end
  def  manager_group
    @count=User.count(:conditions=>["role_id=?",3])
    @data=User.all(:conditions=>["role_id=?",3])
  end
  def developer_group
     @count=User.count(:conditions=>["role_id=?",4])
    @data=User.all(:conditions=>["role_id=?",4])
  end
end
