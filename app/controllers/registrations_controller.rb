class RegistrationsController < Devise::RegistrationsController

	

	def create
		@user = User.new(sign_up_params)
		@user.create_image(params[:user][:image])
		if params[:user][:role]=="doctor"
			@user.doctor_profile = Doctorprofile.new(experience: rand(5..8),appointment_duration: @user.duration.to_i)
		end	

		if @user.save
			redirect_to "/appointments"
		else
			render 'new'
		end		
	end	

	private 

	def sign_up_params
		params.require(:user).permit(:first_name,:last_name,:gender,:date_of_birth,:role,:email,:password,:password_confirmation,:duration)
	end
	
	def account_update_params
   		params.require(:user).permit(:first_name,:last_name,:gender,:date_of_birth,:role,:email,:password,:password_confirmation,:current_password)
   	end

end   			
