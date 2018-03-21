class HospitalManagementMailer < ApplicationMailer

	def notify(user,subject,description)
		@user = user
		@description = description
		mail(to: @user.email, subject: subject) if @user.email.present?
	end	
end
