class RegistrationsController < Devise::RegistrationsController


	def create
		@user = User.new(sign_up_params)
		if @user.save
			@user.image = Image.create({:image => params[:user][:image]})	
			@user.save
			redirect_to "/users/sign_in"
		else
			render 'new'
		end		

	end	

	private 

	def sign_up_params
		params.require(:user).permit(:first_name,:last_name,:gender,:date_of_birth,:role,:email,:password,:password_confirmation)
	end
	
	def account_update_params
   		params.require(:user).permit(:first_name,:last_name,:gender,:date_of_birth,:role,:email,:password,:password_confirmation,:current_password)
   	end
			
end   			
