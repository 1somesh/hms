class SessionsController < Devise::SessionsController

	before_action :clear_cache ,only: [:destroy]
	
	private

	#clear cache before user signout
	def clear_cache
	   	expire_page '/appointments'	
	end

end