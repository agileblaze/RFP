# See how all your routes lay out with "rake routes"
ActionController::Routing::Routes.draw do |map|
  map.resources :announcements

  
  # RESTful rewrites
  
  map.signup   '/signup',   :controller => 'users',    :action => 'new'
  map.register '/register', :controller => 'users',    :action => 'create'
  map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate'
  map.login    '/login',    :controller => 'sessions', :action => 'new'
  map.logout   '/logout',   :controller => 'sessions', :action => 'destroy', :conditions => {:method => :delete}
  map.user_troubleshooting '/users/troubleshooting', :controller => 'users', :action => 'troubleshooting'
  map.user_forgot_password '/users/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.user_reset_password  '/users/reset_password/:password_reset_code', :controller => 'users', :action => 'reset_password'
  map.user_forgot_login    '/users/forgot_login',    :controller => 'users', :action => 'forgot_login'
  map.user_clueless        '/users/clueless',        :controller => 'users', :action => 'clueless'
  
  map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }
    
  map.resources :users, :member => { :edit_password => :get,
                                     :update_password => :put,
                                     :edit_email => :get,
                                     :update_email => :put,
                                     :edit_avatar => :get, 
                                     :update_avatar => :put }                            
  map.resource :session
  # Profiles
  map.resources :profiles
  # Administration
  map.namespace(:admin) do |admin|
    admin.root :controller => 'dashboard', :action => 'index'
    admin.resources :settings
    admin.resources :announcements
    admin.resources :groups,:collection => {:all_group=>:get ,:admin_group=>:get,:bdteam_group=>:get,:manager_group=>:get,:developer_group=>:get}
    admin.resources :commits
    admin.resources :users, :member => { :suspend   => :put,
                                         :unsuspend => :put,
                                         :activate  => :put, 
                                         :purge     => :delete,
                                         :reset_password => :put },
                            :collection => { :pending   => :get,
                                             :active    => :get, 
                                             :suspended => :get, 
                                             :deleted   => :get,
                                             :index     => :get}
    admin.resources :module,:collection=>{}
  end
  map.namespace(:bdteam) do |bdteam|
   #bdteam.root :controller => 'dashboard', :action => 'index'
    bdteam.resources :dashboard,:collection=>{:index=>:get }
  end

  map.namespace(:rfp) do |rfp|
    rfp.resources :rfp_bdteam,:collection=>{ :savea=>:get,:index=>:get,:upload=>:get,:manage_rfp=>:get,:delete_rfp=>:get,:remove_rel_rfp=>:get,:remove_rfp=>:get}
    rfp.resources :rfp_manager,:collection=>{:index=>:get}
    rfp.resources :rfp_admin,:collection=>{:index=>:get,:remove_rfp=>:get}
  end

 map.namespace(:manager) do |manager|
  manager.resources :dashboard,:collection=>{:index=>:get }
 end
  # Dashboard as the default location
  map.root :controller => 'dashboard', :action => 'index'
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end