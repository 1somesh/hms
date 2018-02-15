class AppointmentsController < ApplicationController
  
  before_action :should_be_patient?, only: [:new,:create,:edit,:update]
  before_action :check_authorization, only: [:show,:edit,:update,:destroy]
  before_action :check_status?, only: [:edit,:update,:destroy]
  caches_page :index  

  def index
    @appointment_list = current_user.future_appointment_list    
  end

  def new
    @appointment = current_user.patient_appointments.build
    @doctors_list = User.get_doctors_list
    @slots = Appointment.get_booked_slots(User.where(role: "doctor").first.id,(Time.now+1.day).strftime("%Y-%m-%d"))
  end

  def create
    @appointment = current_user.patient_appointments.new(appointment_params)
    @appointment.initialize_note(current_user.id,@appointment.note)
    duration = @appointment.get_appointment_duration(params[:appointment][:start_time])
    
    if @appointment.save
       ExpiredDateWorker.perform_in(@appointment.date + (duration.strftime("%H").to_i + params[:appointment][:start_time].to_i)*60*60+7*3600,@appointment.id)
       @appointment.create_image(params[:appointment][:image])
       expire_page '/appointments'
       flash[:success] = "Appointment created!"
       redirect_to '/appointments' and return
    else
      time = @appointment.date!=nil ? @appointment.date : Time.now+1.day  
      @slots = Appointment.get_booked_slots(@appointment.doctor.id,time.strftime("%Y-%m-%d"))
      @doctors_list = User.get_doctors_list
      render 'new' and return
    end  

  end

  def update
      @appointment = Appointment.find params[:id]  
      duration = @appointment.get_appointment_duration(params[:appointment][:start_time])
      @appointment.create_image(params[:appointment][:image])
      old_date =  @appointment.date.strftime("%Y-%m-%d").to_date
      new_date = Appointment.get_new_date(params.require(:appointment).permit(:date))
    
      if params[:appointment][:start_time] == nil
         if old_date != new_date
            @appointment.errors.add('appointment','Select a Appointment time')
            @slots = Appointment.get_booked_slots(@appointment.doctor.id,@appointment.date)
            render "edit" and return            
         end   
      else
         @appointment.update_attributes(appointment_update_params)
         @appointment.update_worker(params[:appointment][:start_time],duration)
      end
      expire_page '/appointments'      
      flash[:success] = "Appointment updated!"
      redirect_to "/appointments" 
  end


  def destroy
    @appointment = Appointment.find params[:id]
    @appointment.cancelled!
    render json: {status: "cancelled"}
    flash[:success] = "Appointment cancelled!"
    expire_page '/appointments'
  end

  def show
    @appointment = Appointment.find(params[:id])
    @patient = @appointment.patient
    @notes = @appointment.notes
  end

  def edit
    @appointment = Appointment.find params[:id]
    @slots = Appointment.get_booked_slots(@appointment.doctor.id,@appointment.date)

  end

  def recent
    @appointments = current_user.past_appointment_list
  end


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

  def check_authorization
     appointment = Appointment.find params[:id]  
    if current_user != appointment.doctor && current_user!= appointment.patient
      redirect_to "/error404"
    end  
  end

  def check_status?
    if !Appointment.find(params[:id]).pending? 
        redirect_to "/appointments"
    end  
  end

