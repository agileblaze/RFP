class Manager::DashboardController < ApplicationController
  layout 'manager'
   before_filter :require_login
    def require_login
    if session[:id]==nil
      #redirect_back_or_default(root_path)
      redirect_to  login_url
    else
      user_role=User.find(session[:id])
      if user_role.role_id!=3
        redirect_to  login_url
      end
    end
  end
  def index
  end
end
