class AppointmentsController < ApplicationController
  
  before_action :should_be_patient?, only: [:new,:create,:edit,:update]
  before_action :check_authorization, only: [:show,:edit,:update,:delete]
  before_action :check_status?, only: [:edit,:update,:delete]
  #caches_page :index  

  def index
      @appointment_list = current_user.future_appointment_list
      
  end

  def new
    @appointment = current_user.patient_appointments.build
    @doctors_list = User.get_doctors_list
    @slots = Appointment.get_booked_slots(User.where(role: "doctor").first.id,Time.now.strftime("%Y-%m-%d"))
  end

  def createedi
    @appointment = current_user.patient_appointments.new(appointment_params)
    @appointment.initialize_note(current_user.id,@appointment.note)
    duration = @appointment.doctor.doctor_profile.appointment_duration

    if params[:appointment][:start_time]!= nil
      @appointment.finish_time = (params[:appointment][:start_time].to_time + duration.to_i).strftime("%H:%M:%S").to_time.strftime("%H:%M:%S")
    end

     if @appointment.save
         #expire_page '/appointments'
         ExpiredDateWorker.perform_in(@appointment.date + (duration.strftime("%H").to_i + params[:appointment][:start_time].to_i)*60*60+7*3600,@appointment.id)
         image = params[:appointment][:image]

         if !image.blank?
             @appointment.images.create(image: image)
         end
          flash[:success] = "Appointment created!"
             redirect_to '/appointments'
  
    else
      @slots = Appointment.get_booked_slots(User.where(role: "doctor").first.id,Time.now.strftime("%Y-%m-%d"))
      @doctors_list = User.get_doctors_list
      render 'new'
    end  
  
  end


  def update

      @appointment = Appointment.find params[:id]  
      duration = @appointment.doctor.doctor_profile.appointment_duration
      image = params[:appointment][:image]
      duration = @appointment.doctor.doctor_profile.appointment_duration

      @appointment.images.create(image: image) if image.present?
      @appointment.finish_time = (params[:appointment][:start_time].to_time + duration.to_i).strftime("%H:%M:%S").to_time.strftime("%H:%M:%S") if params[:appointment][:start_time].present?
      
      old_date =  @appointment.date.strftime("%Y-%m-%d").to_date
      date = params.require(:appointment).permit(:date)
      formatted_date = "#{date["date(1i)"]}-#{date["date(2i)"]}-#{date["date(3i)"]}"

      if params[:appointment][:start_time] == nil

         if old_date != formatted_date.to_date
            @appointment.errors.add('appointment','Appointment time should be selected')
            @slots = Appointment.get_booked_slots(@appointment.doctor.id,@appointment.date)
            render "edit"
         else
          flash[:success] = "Appointment updated!"
          redirect_to "/appointments"            
         end   
  
      else
        @appointment.update_attributes(appointment_update_params)
        queue = Sidekiq::ScheduledSet.new
      
        queue.each do |job| 
            if job.args[0].to_i == @appointment.id
              current_job = Sidekiq::ScheduledSet.new.find_job(job.jid)
              current_job.reschedule (@appointment.date + (duration.strftime("%H").to_i + params[:appointment][:start_time].to_i)*60*60+7*3600)
            end  
        end 
         #expire_page '/appointments'
         flash[:success] = "Appointment updated!"
         redirect_to "/appointments"
      end
  end

  def destroy
    @appointment = Appointment.find params[:id]
    @appointment.update(status: 2,start_time: "00:00")
    redirect_to "/appointments"
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
    #formatted_date = "#{date["date(1i)"]}-#{date["date(2i)"]}-#{date["date(3i)"]}"

    if formatted_date.to_date > Date.today
        slots = Appointment.get_booked_slots(params[:doctor_id],formatted_date)
        render json: {status: "success",slots: slots}
    else
        render json: {status: "Date should be in future"} 
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