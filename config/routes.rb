Grundlebox::Application.routes.draw do

  # Admin modules
  match "admin"               => "admin#index",         :as => :admin
  match "admin/login"         => "admin#login",         :as => :admin_login
  get   "admin/logout"        => "admin#logout",        :as => :admin_logout
  get   "admin/denied"        => "admin#denied",        :as => :admin_denied
  get   "admin/help"          => "admin#help",          :as => :admin_help
  
  get   "admin/management"      => "admin/mangement#index",    :as => :admin_management
  
  namespace :admin do
      
    # Simple resourceful routes
    resources :tags
    resources :events
    resources :venues
    resources :assets
    
    # More complex...
    resources :users do
      collection do
        get :writers
        get :editors
        get :subeditors
        get :publishers
        get :administrators
        get :mailing_list_subscribers
      end
    end
  
    resources :articles do
      collection do 
        get :unsubmitted
        get :editing
        get :subediting
        get :publishing
        get :live
        get :inactive
        get "download/(:id)" => "articles#download", :as => :download
      end
      member do
        get "print" => "articles#show", :print => true, :as=>:print
        get "check_lock" => "articles#check_lock", :as => :check_lock
        post "unpublish" => "articles#unpublish", :as=>:unpublish
        post "revert_draft" => "articles#revert_draft", :as=>:revert_draft
      end
    end
    
    resources :asset_folders do
      collection do
        get "/:id/edit"           => "asset_folders#edit", :as => :edit
        put "/:id"                => "asset_folders#update", :as => :update
        delete "/:id"             => "asset_folders#destroy", :as => :destroy
        get "/new"                => "asset_folders#new", :as => :new
        put "/"                   => "asset_folders#create", :as => :update
        get "attach(/*path)"      => "asset_folders#browse_for_attach", :as => :attach
        get "attachment_form/:id" => "asset_folders#attachment_form", :as => :attachment_form
        get "/*path"              => "asset_folders#index", :as => :browse
      end
    end
    
  end
  
end
