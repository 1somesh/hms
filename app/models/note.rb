class Note < ActiveRecord::Base
	belongs_to :appointment
	validate :description_present?

	def description_present?
		if description.blank?
			errors.add('notes',"Enter a note")
		end	

	end
end
