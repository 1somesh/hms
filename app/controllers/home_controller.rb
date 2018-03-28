class HomeController < ApplicationController

	
	def index
	  	if user_signed_in?
	  		redirect_to "/appointments"
	  	else
	  		redirect_to new_user_session_path 
	  	end	
	end

	
	def edit
		@user = User.find(current_user.id)
		respond_to do |format|
        	 format.html 
      	end 
	end 

	def change_profile_pciture
		image = Image.new image: params[:user][:image]
		if image.valid?
			current_user.image = image
		end
		
		if current_user.save
			redirect_to "/home/profile"
		else
			render 'profile'
		end	
	end

end
