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
                 
    get   "admin/help"    => "admin#help",   :as => :help
  
    resources :articles do
      collection do 
        get :unsubmitted
        get :editing
        get :subediting
        get :publishing
        get :live
        get :inactive
        get :download
      end
      member do
        get "print" => "articles#show", :print => true, :as=>:print
        get "check_lock" => "articles#check_lock", :as => :check_lock
        post "unpublish" => "articles#unpublish", :as=>:unpublish
        put "draft" => "articles#draft", :as => :draft
      end
    end
    
    
  end
  
end
