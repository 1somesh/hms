	class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def facebook
		user = User.from_omniauth(request.env["omniauth.auth"])
	    check_persistance(user)
	end	
	
	def twitter
		auth = request.env["omniauth.auth"]
	  	user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
		check_persistance(user)
	end	

	def google_oauth2
		user = User.from_omniauth(request.env["omniauth.auth"])
   	    check_persistance(user)
	end

	private

	def check_persistance (user)
		if user.persisted?
	      flash.notice = "Signed in!"
		    sign_in_and_redirect user, event: :authentication
	    else
	      session["devise.user_attributes"] = user.attributes
	      redirect_to new_user_registration_url
	    end
	end

end	