class NotesController < ApplicationController


	def create
		@appointment = Appointment.find params[:appointment_id]
		@appointment.initialize_note(current_user.id, params[:note][:description])

		if @appointment.save
			render json: {status: "success",description: params[:note][:description],by: current_user.first_name}
		else
			render json: {status: "faliure"}
		end	
	end			


	private 

	def note_params
		params.require(:note).permit(:description)
	end

end
