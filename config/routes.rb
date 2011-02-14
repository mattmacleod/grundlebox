Rails.application.routes.draw do

  ############################################################################
  # Admin section
  ############################################################################
  
  # Admin modules
  match "admin"               => "admin#index",         :as => :admin
  match "admin/login"         => "admin#login",         :as => :admin_login
  get   "admin/logout"        => "admin#logout",        :as => :admin_logout
  get   "admin/help"          => "admin#help",          :as => :admin_help
  
  # Admin errors
  match "admin/404"           => "admin#display_404",   :as => :admin_error_404
  match "admin/403"           => "admin#display_403",   :as => :admin_error_403
  match "admin/500"           => "admin#display_500",   :as => :admin_error_500
  
  
  namespace :admin do
  
    # Simple routes
    get   "management"      => "management#index",    :as => :admin_management
    
    # Simple resourceful routes
    resources :tags
    resources :cities
    
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
        get "/:id/edit"            => "asset_folders#edit", :as => :edit
        put "/:id"                 => "asset_folders#update", :as => :update
        delete "/:id"              => "asset_folders#destroy", :as => :destroy
        get "/new"                 => "asset_folders#new", :as => :new
        put "/"                    => "asset_folders#create", :as => :update
        get "use_attach/:id"       => "asset_folders#use_attach", :as => :use_attach
        match "attach(/*path)"     => "asset_folders#attach", :as => :attach
        get "attach_variation/:id" => "asset_folders#attach_variation", :as => :attach_variation
        get "/*path"               => "asset_folders#index", :as => :browse
      end
    end
    
    resources :assets do
      collection do
        get  "zip_upload"           => "assets#zip_upload", :as => :zip_upload
        post "create_from_zip"      => "assets#create_from_zip", :as => :create_from_zip
      end
    end
    
    resources :events do
      collection do
        match "build_performances"    => "events#build_performances", :as => :build_performances
        match "for_attachment"        => "events#for_attachment", :as => :for_attachment
      end
    end
    
    resources :venues do
      collection do
        match "for_attachment"        => "venues#for_attachment", :as => :for_attachment
      end
    end
    
    resources :pages do
      collection do
        put "/update_order"  => "pages#update_order", :as => :update_order
      end
    end
    
    resources :comments do
      member do
        post "/approve" => "comments#approve", :as => :approve
      end
    end
    
  end
  
  
  # Default admin error page for nonexistent routes
  match "admin/*path" => "admin#display_404"
   
   
  ############################################################################
  # API section
  ############################################################################
  get "api/v:version/users(.:format)" => "api#users", :as => :api_users
  get "api/v:version/events(.:format)" => "api#events", :as => :api_events
  get "api/v:version/venues(.:format)" => "api#venues", :as => :api_venues
  get "api/v:version/articles(.:format)" => "api#articles", :as => :api_articles
  
  
end
