module AdminHelper
  
  # General global admin helpers
  ############################################################################
  def page_title
    [@page_title, Grundlebox::Config::SiteTitle].compact.join(" | ")
  end
  
  
  # Ajax and pagination
  ############################################################################
  def ajax_spinner(base)
    image_tag( "/images/admin/spinner.gif", :alt => "Loading...", :class => "spinner", :id => "#{base}_spinner" )
  end
  
  def continuous_pagination(name)
    out = "<div id=\"pagination_loading_wrapper\"><div id=\"pagination_loading\">Loading..."
    out << image_tag("/images/admin/spinner.gif", :alt=>"Loading...", :id => "#{name}_spinner")
    out << "</div></div>"
    return out.html_safe
  end
  
  
  # Form helpers
  ############################################################################
  
  def labelled_form_for(*args, &block)
    raise ArgumentError, "Missing block" unless block_given?
    options = args.extract_options!.merge( :builder => Grundlebox::Forms::LabelledFormBuilder )
    options[:html] ||= {}
    form_for(*(args << options), &block)
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
