class Admin::ModuleController < ApplicationController
  require_role :admin
  layout 'admin'
  def index
    @module_count=ProjectModule.count
    @module=ProjectModule.all

  end

end