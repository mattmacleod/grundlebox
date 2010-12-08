module AdminHelper
  
  def page_title
    [@page_title, Grundlebox::Config::SiteTitle].compact.join(" | ")
  end
  
  
  # Menu helpers
  ############################################################################
  
  def admin_main_menu
    "<li class=\"#{"in" unless controller_name=="admin"}active\">#{link_to "Dashboard", "/admin"}</li>".html_safe +
    Grundlebox::Config::AdminModules.collect do |mod|
      if mod[:roles].include?( current_user.role.downcase.to_sym )
        path = "/admin/#{mod[:controllers].first}"
        "<li class=\"#{"in" unless mod[:controllers].include?(controller_name.to_sym)}active\">#{link_to mod[:title].to_s.humanize, path}</li>"
      end
    end.compact.join("\n").html_safe
  end

  def admin_sub_menu
    submenu = controller.class.subsections.collect do |mod|
      if mod[:roles].include?( current_user.role.downcase.to_sym )
        path = "/admin/#{controller_name=="admin" ? "" : controller_name + "/"}#{mod[:actions].first==:index ? "" : mod[:actions].first}".chomp("/")
        "<li class=\"#{"in" unless ((mod[:actions].include?(action_name.to_sym) && @forced_active_subsection.blank?)  || @forced_active_subsection==mod[:title]) }active\">#{link_to mod[:title].to_s.humanize, path}</li>"
      end
    end
    return submenu.compact.join("\n").html_safe
  end
  
  
end