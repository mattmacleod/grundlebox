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
  
end