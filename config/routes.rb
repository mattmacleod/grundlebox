Grundlebox::Application.routes.draw do

  # Admin modules
  match "admin"         => "admin#index",  :as => :admin
  match "admin/login"   => "admin#login",  :as => :admin_login
  get   "admin/logout"  => "admin#logout", :as => :admin_logout
  get   "admin/denied"  => "admin#denied", :as => :admin_denied
  
  namespace :admin do
    
    resources :users do
      collection do
        get :writers
        get :editors
        get :subeditors
        get :publishers
        get :administrators
      end
    end
                 
    get   "help"    => "help",   :as => :help
  
  end
  
end
