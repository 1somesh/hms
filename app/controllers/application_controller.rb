class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |error| 
  	 flash[:notice] = "Access Denied"
  	 redirect_to "/" 
  end

  rescue_from ActionController::UnknownFormat, with: :format_not_supported

  def format_not_supported
    	render(text: 'This format is not supported by the Application', status: 404)
  end
 
end
