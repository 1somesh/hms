class HomeController < ApplicationController

	def index
	  	if user_signed_in?
	  		puts current_user.inspect
	  		redirect_to "/appointments"
	  	else
	  		redirect_to new_user_session_path 
	  	end	
  end

 def profile

 end


end
