class SessionsController < ApplicationController

	#before_action :clear_cache ,only: [:destroy]
	
 
  # def destroy
  #   session[:user_id] = nil
  #   redirect_to root_url
  # end

	private
  
	#clear cache before user signout
	def clear_cache
	   	expire_page '/appointments'	
	end

end