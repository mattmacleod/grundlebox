ActionController::Base.class_eval do

  #
  # Handle role filtering using controller methods
  #
  
  # Find all of the actions in the subsections method. Then create 
  # before_filters for each of these, with the roles that have access.
  def self.grundlebox_permissions( *values )
    
    values.each do |subsection|
      before_filter Proc.new{
        if subsection[:roles].include? current_user.role.downcase.to_sym
          return true
        else
          redirect_to admin_error_403_path and return false
        end
      }, :only => subsection[:actions]
    end
    
  end

end
