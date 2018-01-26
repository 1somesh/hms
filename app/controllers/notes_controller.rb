class NotesController < ApplicationController

	
	def new
		@note = Note.new
		@appointment = Appointment.find params[:appointment_id]
	end

	def create
		@appointment = Appointment.find params[:appointment_id]
		@appointment.create_note(current_user.id, params[:note][:description])

		if @appointment.save
			redirect_to @appointment
		else
			render 'new'
		end	
	end	


	private 

	def note_params
		params.require(:note).permit(:description)
	end

end
