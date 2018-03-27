class Note < ActiveRecord::Base
	belongs_to :appointment
	validate :description_present?
	belongs_to :user

	#Validates discription should be present
	def description_present?
		if description.blank?
			errors.add('notes',"Enter a note")
		end	

	end
end
