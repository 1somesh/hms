class SessionsController < Devise::SessionsController

	before_action :clear_cache ,only: [:destroy]

	def clear_cache
	   	expire_page '/appointments'	
	end

end