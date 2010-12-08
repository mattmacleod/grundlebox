# Main app configuration file

class Grundlebox::Config
  
  # Site configuration
  SiteTitle   = "Grundlebox"
  SiteEmail   = "hello@grundlebox.co.uk"
  SiteBaseUrl = "http://www.grundlebox.co.uk"
  
  # Access and authentication
  SessionTimeout = 4.hours
  AdminRoles     = ["ADMIN", "PUBLISHER","SUBEDITOR", "EDITOR", "WRITER"]
  
  # Validation Regexps
  EmailRegexp =  /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  UrlRegexp   =  /[a-zA-Z0-9_]+/i
  
  # Magick geometry string
  ImageFileVersions = { 
    :large   => ["900x675",   :jpg],
    :wide    => ["540x",      :jpg],
    :article => ["220x",      :jpg],
    :thumb   => ["125x100#",  :jpg],
    :tiny    => ["60x40#",    :jpg]
  }
  
  # Asset uploading
  AssetMaxUploadSize = 20.megabytes
  AssetContentTypes = [
    "image/jpeg", "image/pjpeg", "image/png", "image/x-png", "image/gif",
    "application/pdf", "application/msword", "application/vnd.ms-excel",
    "application/vnd.ms-powerpoint", "application/octet-stream"
  ]
  
  # Admin menu system
  AdminModules = [
    { :title => :articles,    :controllers => [:articles],           :roles => [:writer, :editor, :subeditor, :publisher, :admin] },
    { :title => :pages,       :controllers => [:pages],              :roles => [:publisher, :admin] },
    { :title => :media,       :controllers => [:assets, :galleries], :roles => [:editor, :subeditor, :publisher, :admin] },
    { :title => :events,      :controllers => [:events, :venues],    :roles => [:writer, :editor, :subeditor, :publisher, :admin] },
    { :title => :users,       :controllers => [:users],              :roles => [:admin] },
    { :title => :management,  :controllers => [:management, :tags],  :roles => [ :admin] }   
  ]
  
end