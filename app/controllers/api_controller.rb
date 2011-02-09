class ApiController < ApplicationController
  
  # Controller setup
  ############################################################################
  before_filter :validate_code
  after_filter  :record_request, :if => Proc.new { !!@api_key }
  
  
  # API methods
  ############################################################################
  
  # Get users.
  # Valid parameters: role(string)
  def users
    @users = params[:role] ? User.where(:role => params[:role]) : User.all
    respond_to do |format|
      format.xml { render :xml => @users.to_xml }
      format.json { render :json => @users.to_json }
    end
  end
  
  
  
  # Protected utility methods
  ############################################################################
  private
  
  # Check the the supplied API request is valid.
  def validate_code
    
    # Don't validate in dev mode
    return true if Rails.env=="development"
    
    begin
      
      id    = params[:key].to_s.split("-")[0]
      code  = params[:key].to_s.split("-")[1]
      
      @version = params[:version].to_i
      
      @api_key = ApiKey.find( id )
      if ( @api_key && @api_key.enabled? && @api_key.code==code )
        return true
      else
        reject and return false
      end
      
    rescue
      reject and return false
    end
    
  end
  
  # Reject invalid requests
  def reject
    render :xml=>"", :status => :forbidden
  end
  
  def record_request
    @api_key.record!( request.url, response.status, request.remote_ip, @version )
  end
  
end
