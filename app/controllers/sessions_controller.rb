class SessionsController < ApplicationController

	#before_action :clear_cache ,only: [:destroy]
	
  # def create
  #   user = User.from_omniauth(env["omniauth.auth"])
  #   session[:user_id] = user.id
  #   puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
  #   puts session[:user_id]
  #   redirect_to root_url
  # end

  # def destroy
  #   session[:user_id] = nil
  #   redirect_to root_url
  # end

	#private
	#clear cache before user signout
	# def clear_cache
	#    	expire_page '/appointments'	
	# end
end