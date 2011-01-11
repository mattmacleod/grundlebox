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
  
  
  # Action links
  ############################################################################
  
  def delete_link(content, url)
    link_to content, url, :method => :delete, :class => :destroy, :confirm => "Are you sure you want to delete this item?"
  end
  
  def approve_link(content, url)
    link_to content, url, :class => :approve
  end
  
  
  
  # Formatting
  ############################################################################
  
  def print_time( value, options={} )
    options.reverse_merge!( { :if_empty => "unknown", :long => false} )
    return options[:if_empty] unless value && value.is_a?(Time)
    unless options[:long]
      if value > 6.days.ago
        return value.strftime("%I:%M%p on %A")
      end
      return value.strftime("%I:%M%p on %d %b %Y")
    else
      return value.strftime("%I:%M%p on %A %d %B %Y")
    end
  end
  
  def print_bool( value )
    value ? "Yes" : "No"
  end
  
  
  
  
  # Form helpers
  ############################################################################
  
  def labelled_form_for(*args, &block)
    raise ArgumentError, "Missing block" unless block_given?
    options = args.extract_options!.merge( :builder => Grundlebox::Forms::LabelledFormBuilder )
    options[:html] ||= {}
    form_for(*(args << options), &block)
  end
  
  def form_errors(obj)
    errors = obj.errors
    return if errors.blank?
    
    error_messages = obj.errors.map do |msg|
      content_tag(:li, 
        msg[0].to_s.humanize + " " + h(msg[1])
      ) 
    end.join.html_safe
    
    output = "".html_safe
    output << content_tag(:h2, 
      "There #{(errors.length==1 ? "was an error" : "were errors")} "+
      "in your form:"
    ).html_safe
    output << content_tag(:ul, error_messages).html_safe
    return content_tag(:div, output, :class=>"errors").html_safe
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
