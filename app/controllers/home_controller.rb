class HomeController < ApplicationController

	#mapped with root route
	def index
	  	if user_signed_in?
	  		redirect_to "/appointments"
	  	else
	  		redirect_to new_user_session_path 
	  	end	
	end

	#renders a form to edit user
	def edit
		@user = User.find(current_user.id)
		respond_to do |format|
        	 format.html 
      	end 
	end 

	#changes the profile picture of the user
	def change_profile_pciture
		image = params[:user][:image]
		current_user.create_image(params[:user][:image])
		if current_user.save
			redirect_to "/home/profile"
		else
			render 'profile'
		end	
	end

end
