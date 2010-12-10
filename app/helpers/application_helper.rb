module ApplicationHelper
  
  # General elements
  ############################################################################
  
  def flash_message
    return unless flash
    return [:error, :warning, :notice].map do |flash_type|
      unless flash[flash_type].blank?
      	"<div class=\"flash_wrapper\"><div class=\"flash flash_#{flash_type}\"><span class=\"icon #{flash_type}\"></span><span class=\"text\">#{flash[flash_type]}</span></div></div>"
      end 
    end.join.html_safe
  end
  
  def note(content, options={})
    options.reverse_merge!( {:type=>:info} )
    output = "<div class=\"note #{options[:type]}\">"+
             "<span class=\"icon #{options[:type]}\"></span><span class=\"text\">#{content}</span>"+
             "</div>"
    return output.html_safe
  end
  
end
