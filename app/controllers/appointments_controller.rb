class AppointmentsController < ApplicationController
  

  #returns  the list of future appointments.
  def index
    @appointment_list = current_user.future_appointment_list    
  end

  #renders the new apointment form 
  def new
    @appointment = current_user.patient_appointments.build
    @doctors_list = User.get_doctors_list
    @slots = Appointment.get_booked_slots(User.where(role: "doctor").first.id,(Time.now+1.day).strftime("%Y-%m-%d"))
    authorize! :new, @appointment 
  end

  #creates appointment and sets the sidekiq background worker
  def create
    @appointment = current_user.patient_appointments.new(appointment_params)
    authorize! :create, @appointment
    @appointment.initialize_note(current_user.id,@appointment.note)
    duration = @appointment.get_appointment_duration(params[:appointment][:start_time])
    
    if @appointment.save
       #creating the sidekiq worker
       ExpiredDateWorker.perform_in(@appointment.date + (duration.strftime("%H").to_i + params[:appointment][:start_time].to_i)*60*60+7*3600,@appointment.id)
       @appointment.create_image(params[:appointment][:image])
       flash[:success] = "Appointment created!"
       redirect_to '/appointments'
    else
      time = @appointment.date!=nil ? @appointment.date : Time.now+1.day  
      @slots = Appointment.get_booked_slots(@appointment.doctor.id,time.strftime("%Y-%m-%d"))
      @doctors_list = User.get_doctors_list
      render 'new'
    end  

  end

  #update the appointment and the sidekiq worker
  def update
      @appointment = Appointment.find params[:id]  
      authorize! :update, @appointment
      duration = @appointment.get_appointment_duration(params[:appointment][:start_time])
      @appointment.create_image(params[:appointment][:image]) 
      new_date = Appointment.get_new_date(params.require(:appointment).permit(:date))

      if params[:appointment][:start_time] == nil
         if @appointment.date.strftime("%Y-%m-%d").to_date != new_date
            @appointment.errors.add('appointment','Select a Appointment time')
            @slots = Appointment.get_booked_slots(@appointment.doctor.id,@appointment.date)
            render "edit" and return            
         end   
      else
         @appointment.update_attributes(appointment_update_params)
         @appointment.update_worker(params[:appointment][:start_time],duration)
      end
      flash[:success] = "Appointment updated!"
      redirect_to "/appointments" 
  end

  #changes the status of appointment from pending to cancelled
  def destroy
    @appointment = Appointment.find params[:id]
    authorize! :destroy, @appointment
    @appointment.cancelled!
    render json: {status: "cancelled"}
    flash[:success] = "Appointment cancelled!"

  end

  def show
    @appointment = Appointment.find(params[:id])
    authorize! :show, @appointment
    @patient = @appointment.patient
    @notes = @appointment.notes

  end

  def edit
    @appointment = Appointment.find params[:id]
    authorize! :edit, @appointment    
    @slots = Appointment.get_booked_slots(@appointment.doctor.id,@appointment.date)

  end

  #gives list of all passed both completed and cancelled appointments
  def recent
    @appointments = current_user.past_appointment_list
  end

  #returns available slots for a doctor on the specified day
  def get_available_slots
    formatted_date = params[:date]
    if formatted_date.to_date > Date.today
        slots = Appointment.get_booked_slots(params[:doctor_id],formatted_date)
        render json: {status: "success",slots: slots}
    else
        render json: {status: "Select a future date"} 
    end    
  end


end

  private

  def appointment_params
    params.require(:appointment).permit(:doctor_id,:date,:note,:start_time)
  end

  def appointment_update_params
    params.require(:appointment).permit(:date,:start_time)
  end

  #only the doctor or patient of a appointment can change the appointment details
  def check_authorization
     appointment = Appointment.find params[:id]  
    if current_user != appointment.doctor && current_user!= appointment.patient
      redirect_to "/error404"
    end  
  end

  #only pendind appointments can be cancelled or edited
  # def check_status?
  #   if !Appointment.find(params[:id]).pending? 
  #       redirect_to "/appointments"
  #   end  
  # end

