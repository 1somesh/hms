class AppointmentsController < ApplicationController
  

  before_action :should_be_patient, only: [:new,:create,:edit,:update]
  before_action :should_be_doctor, only: [:recent]

  def index
    @list = current_user.appointment_list
  end

  def new
    @appointment = current_user.doctor_appointments.build
  end

  def create
    image = params[:appointment][:image]
    cause = params[:note][:description]    
    @appointment = current_user.patient_appointments.new(appointment_params)
    @note = Note.new({:user_id => current_user.id,:description => cause})
     
     if @appointment.valid?  &&  @note.valid?
           
         @appointment.save
         @note.appointment_id = @appointment.id
         @note.save

         if !image.blank?
             @appointment.images.create({:image => image})
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
       @appointment.images.create({:image => image})
    end
    
    # if appointment_date < @appointment.date
    #    @appointment.errors.add(:appointment_date, "should be more than current booking date")
    #   render 'edit'
    # else
     
      if  @appointment.update_attributes(appointment_update_params)
         redirect_to "/appointments"
      else
        redirect_to edit_appointment_path(@appointment)
      end  

  end

  def destroy
    @appointment = Appointment.find params[:id]
    @appointment.status = 2
    @appointment.save
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
    @appointments = Appointment.where(["date < ?" ,DateTime.now])
  end

  private

  def appointment_params
    params.require(:appointment).permit(:doctor_id,:date)
  end

  def appointment_update_params
    params.require(:appointment).permit(:date)
  end

  def should_be_patient
    if !current_user.patient?
        redirect_to '/appointments'     
    end  
  end

  def should_be_doctor
    if !current_user.doctor?
        redirect_to '/appointments'
    end 
  end

end