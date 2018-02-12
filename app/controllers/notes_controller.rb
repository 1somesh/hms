class NotesController < ApplicationController

	before_action :check_authorization, only: [:create]

	def new
	end

	def create
		@appointment = Appointment.find params[:appointment_id]
		@appointment.initialize_note(current_user.id, params[:note][:description])

		if @appointment.save
			render json: {status: "success",description: params[:note][:description],by: params[:note][:by]}
		else
			render json: {status: "faliure"}
		end	
	end	


	private 

	def note_params
		params.require(:note).permit(:description)
	end

	 def check_authorization
     appointment = Appointment.find params[:appointment_id]  

    if current_user != appointment.doctor && current_user!= appointment.patient
      redirect_to "/error404"
    end  
  end

end
