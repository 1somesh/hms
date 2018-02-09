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

	def route_error

	end	

	def edit
		@user = User.find(current_user.id)
	end

	def update

	    if params[:user][:image]!= nil
	        current_user.image.update({:image => params[:user][:image]})
	    end    

	    current_user.update(params.require(:user).permit(:first_name,:last_name,:role))
	          redirect_to "/home/profile"
	end  
	

	def error404
		
	end	

end
