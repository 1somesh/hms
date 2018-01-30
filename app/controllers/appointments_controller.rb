class AppointmentsController < ApplicationController
  

  before_action :should_be_patient?, only: [:new,:create,:edit,:update]
  before_action :should_be_doctor?, only: [:recent]

  def index
      @appointment_list = current_user.future_appointment_list
  end


  def new
    @appointment = current_user.patient_appointments.build
    @doctors_list = User.where(role: "doctor")
    @slots = get_booked_slots(User.where(role: "doctor").first.id,Time.now.strftime("%Y-%m-%d"))

  end

  def create

    @appointment = current_user.patient_appointments.new(appointment_params)
    @appointment.create_note(current_user.id,@appointment.note)
    duration = @appointment.doctor.doctorprofile.appointment_duration
    #@appointment.finish_time = params[:appointment][:start_time] + duration.strftime('%H').to_i*60*60
     if @appointment.save

         image = params[:appointment][:image]

         if !image.blank?
             @appointment.images.create(image: image)
         end
             redirect_to '/appointments'

    else
      @slots = get_booked_slots(User.where(role: "doctor").first.id,Time.now.strftime("%Y-%m-%d"))
      @doctors_list = User.where(role: "doctor")
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
         redirect_to edit_appointment_path(@appointment)
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

  # def book_appointment
  #   slot = Slot.new(doctor_id: 3,start_time: "#{params[:value]}:00:00",finish_time: "#{params[:value]+1.hour}:00:00")
  #   slot.save
  #   render json: {value: params[:value]}  
  # end


  def get_available_slots
    date = params.require(:appointment).permit(:date)
    formatted_date = "#{date["date(1i)"]}-#{date["date(2i)"]}-#{date["date(3i)"]}"
    if formatted_date.to_date >= Date.today
        slots = get_booked_slots(params[:appointment][:doctor_id],formatted_date)
        render :json => {status: "success",slots:  slots,date: formatted_date,doctor_id: params[:appointment][:doctor_id]}
    else
        render :json => {status: "faliure"} 
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


  def get_booked_slots(doctor_id,selected_date)
  
    @appointments = Appointment.where(doctor_id: doctor_id,date: selected_date) 
    @list = []

    (5...11).each do |time|

          bool = true
          @appointments.each do |app|
                if app.start_time!=nil && app.start_time.strftime('%H').to_i  == time
                  bool = false
                end
          end

          if bool
            @list.push(time)
          end 
    end
    @list
  end  

   
    

