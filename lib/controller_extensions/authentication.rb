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

end
