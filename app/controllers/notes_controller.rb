class NotesController < ApplicationController

	
	def new
		@note = Note.new
		@appointment = Appointment.find params[:appointment_id]
	end

	def create
		@appointment = Appointment.find params[:appointment_id]
		@appointment.notes.new({:description => params[:note][:description],:user_id=>params[:user_id]})
		
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
