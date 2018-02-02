class AppointmentsController < ApplicationController
  

  before_action :should_be_patient?, only: [:new,:create,:edit,:update]
  before_action :should_be_doctor?, only: [:recent]

  def index
      @appointment_list = current_user.future_appointment_list
  end


  def new
    @appointment = current_user.patient_appointments.build
    @doctors_list = User.get_doctors_list
    @slots = Appointment.get_booked_slots(User.where(role: "doctor").first.id,Time.now.strftime("%Y-%m-%d"))
  end

  def create

    @appointment = current_user.patient_appointments.new(appointment_params)
    @appointment.initialize_note(current_user.id,@appointment.note)
    duration = @appointment.doctor.doctor_profile.appointment_duration
    #@appointment.finish_time = params[:appointment][:start_time].to_i + duration.strftime('%H').to_i*60*60

     if @appointment.save

         ExpiredDateWorker.perform_at(@appointment.date + (duration.strftime("%H-%M-%S").to_i + params[:appointment][:start_time].to_i)*60*60,@appointment.id)
         image = params[:appointment][:image]

         if !image.blank?
             @appointment.images.create(image: image)
         end
             redirect_to '/appointments'
    

    else
      @slots = Appointment.get_booked_slots(User.where(role: "doctor").first.id,Time.now.strftime("%Y-%m-%d"))
      @doctors_list = User.get_doctors_list
      render 'new'
    end  
  end


  def update
   #appointment_date = Date.civil(*params[:event].sort.map(&:last).map(&:to_i))
   #appointment_date = params[:appointment][:date]

    @appointment = Appointment.find params[:id]
    
      image = params[:appointment][:image]

      if image!= nil
         @appointment.images.create(image: image)
      end
    

      if @appointment.update_attributes(appointment_update_params)
         redirect_to "/appointments"
      else
         render 'edit'
      end  

  end

  def destroy
    @appointment = Appointment.find params[:id]
    @appointment.update(status: 2)
    redirect_to "/appointments"
  end

  def show
    @appointment = Appointment.find(params[:id])
    @patient = @appointment.patient
    @notes = @appointment.notes
  end

  def edit
    @appointment = Appointment.find params[:id]
  end

  def recent
    @appointments = current_user.past_appointment_list
  end


  def get_available_slots
    formatted_date = params[:date]
    #formatted_date = "#{date["date(1i)"]}-#{date["date(2i)"]}-#{date["date(3i)"]}"

    if formatted_date.to_date >= Date.today
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
    params.require(:appointment).permit(:date)
  end


 
   

   
    

