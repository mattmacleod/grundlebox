module AdminHelper
  
  def page_title
    [@page_title, Grundlebox::Config::SiteTitle].compact.join(" | ")
  end
  
end
