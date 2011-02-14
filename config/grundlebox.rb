# Default configuration file

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
  
  # Article types
  ArticleTemplates  = ["Normal"]  
  ArticleTypes  = { 
    :article       => "Generic article",
    :album_review  => "Album review",
    :single_review => "Single review",
    :gig_review    => "Gig review",
    :film_review   => "Film review",
    :book_review   => "Book review",
    :game_review   => "Game review",
    :venue_review  => "Venue review",
    :feature       => "Feature",
    :review        => "Generic review",
    :preview       => "Generic preview"
  } 
  PageTypes = {
    :text     => "Text",
    :articles => "Article listing",
    :events   => "Event listing",
    :venues   => "Venue listing",
    :blogs    => "Blog listing",
    :competition => "Competition"
  }
  PageSortOrder = {
    :newest => "Newest",
    :name   => "Alphabetical"
  }
  
  # Magick geometry string
  ImageFileVersions = { 
    :large   => ["900x675>",   :jpg],
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
    "application/vnd.ms-powerpoint"
  ]
  
  # Admin menu system
  AdminMenus = YAML::load( File.read( File.dirname(__FILE__) + '/grundlebox_menu.yml' ) )
  
  # API keys
  GoogleApiKey = "ABQIAAAA_a2Y8YnvGdeGgoGFUyYotBT2yXp_ZAY8_ufC3CFXhHIE1NvwkxQDT74lJaTBe_PAvumnRp3_dubVrg"
  
  # Mapping
  DefaultAdminMapLocation = "53.800651,-4.042969"
  
  # Affiliates
  AffiliateCodes = {
    "Ticket Master" => "ticketmaster"
  }
  
  TicketTypes = {
    "Unticketed" => "unticketed",
    "Sold out" => "sold_out",
    "On the door" => "on_door",
    "Advance purchase" => "advance"
  }
  
  # Admin counts
  AdminPaginationLimit = 20
  AdminAssetPaginationLimit = 20
  EventAttachmentLimit = 20
  VenueAttachmentLimit = 20
  
  
end