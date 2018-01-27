class AppointmentsController < ApplicationController
  

  before_action :should_be_patient?, only: [:new,:create,:edit,:update]
  before_action :should_be_doctor?, only: [:recent]

  def index
      #@appointment_list = Appointment.includes(:doctor).where(patient_id: current_user.id)
      @appointment_list = current_user.future_appointment_list
  end

  def new
    @appointment = current_user.patient_appointments.build
    @slots = get_booked_slots
    puts @slots.inspect
  end

  def create
    @appointment = current_user.patient_appointments.new(appointment_params)
    @appointment.create_note(current_user.id,@appointment.note)

     if @appointment.save

         image = params[:appointment][:image]

         if !image.blank?
             @appointment.images.create(:image => image)
         end
             redirect_to '/appointments'

    else
      render 'new'
    end  
  end


  def update
   # appointment_date = Date.civil(*params[:event].sort.map(&:last).map(&:to_i))
   #appointment_date = params[:appointment][:date]

    @appointment = Appointment.find params[:id]
    

      image = params[:appointment][:image]

      if image!= nil
         @appointment.images.create(image: image)
      end
    

      if  @appointment.update_attributes(appointment_update_params)
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

  def book_appointment
    slot = Slot.new(doctor_id: 3,start_time: "#{params[:value]}:00:00",finish_time: "#{params[:value]+1.hour}:00:00")
    slot.save
    render json: {value: params[:value]}  
  end



  end

  private

  def appointment_params
    params.require(:appointment).permit(:doctor_id,:date,:note)
  end

  def appointment_update_params
    params.require(:appointment).permit(:date)
  end

  def get_booked_slots

    doctor_id = 3
    selected_date = "2018-01-03"
    @slots = Slot.where(doctor_id: doctor_id)#, appointment_date: selected_date) 

    @list = []

    (5...11).each do |time|

          bool = true
          @slots.each do |app|
                puts app.start_time.inspect
                #puts app.split(':').first
                if app.start_time.strftime('%H').to_i  == time
                  bool = false
                end
          end

          if bool
            @list.push(time)
          end 
    end 
  @list 
    


end