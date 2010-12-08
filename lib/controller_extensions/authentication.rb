ActionController::Base.class_eval do

  #
  # Handle role filtering using controller methods
  #
  
  # Find all of the actions in the subsections method. Then create 
  # before_filters for each of these, with the roles that have access.
  def self.build_permissions
    
    subsections.each do |subsection|
      subsection[:actions].each do |action|
        before_filter Proc.new{
          if subsection[:roles].include? current_user.role.downcase.to_sym
            return true
          else
            redirect_to admin_denied_path and return false
          end
        }, :only => action
      end
    end
    
  end
  
  # Does the user have permission to access the requested action?
  def self.has_permission(subsection)
    
    # Get the subsection we're requesting
    subsection = subsections.select{|s| s[:actions].include?(subsection.to_sym) }.first
    
    # Yes if it exists and is in the list. No if it doesn't or isn't.
    return false unless subsection
    return subsection[:roles].include?( current_user.role.downcase.to_sym )
    
  end
  
end
