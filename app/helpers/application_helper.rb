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
  
end
