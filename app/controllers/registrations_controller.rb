class RegistrationsController < Devise::RegistrationsController

	after_action :clear_cache ,only: [:update]

	#overriding default devise create action
	def create
		@user = User.new(sign_up_params)
		@user.create_image(params[:user][:image])
		if @user.doctor?
			@user.doctor_profile = Doctorprofile.new(appointment_duration:  @user.duration)
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

   	def clear_cache
	   	expire_page '/appointments'	
	end
	
end   			
