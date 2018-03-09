class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found 
  rescue_from CanCan::AccessDenied do |error| 
  	 flash[:notice] = "Access Denied"
  	 redirect_to "/" 
  end
  #rescue_from ActionController::RoutingError, :with => :record_not_found	
 

    protected
	
	  def should_be_patient?
	    redirect_to '/' and return if current_user.blank?
	    redirect_to '/', notice: 'Invalid authorization' and return unless current_user.patient?
	    return if current_user.patient?
	  end

	  def should_be_doctor?
	    redirect_to '/' and return if current_user.blank?
	    redirect_to '/' and return if current_user.patient?
	  end

  	  def record_not_found 
	  	redirect_to '/error404'	
  	  end

 
   
 
end
