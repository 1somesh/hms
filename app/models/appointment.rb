class Appointment < ActiveRecord::Base

	belongs_to :doctor  ,class_name: User
	belongs_to :patient ,class_name: User
	has_many :notes
	has_many :images ,as: :imageable

	validates :date ,:start_time,presence: true
	validate :check_appointment_date
	validates_associated :notes


	enum status: [:pending,:completed,:cancelled]
	attr_accessor :note


  def check_appointment_date
    if  date  < Date.today
      errors.add(:appointment_date, "can't be in the past")
    end
  end

  def initialize_note(user_id,note)
  	self.notes.new(user_id: user_id, description: note)
  end


  def self.get_booked_slots(doctor_id,selected_date)
  
    duration = Doctorprofile.where(doctor_id: doctor_id).first.appointment_duration.strftime("%H").to_i
    appointments = Appointment.where(doctor_id: doctor_id,date: selected_date) 
    list = []

    time = 5
    loop do 

          bool = true
          appointments.each do |app|
                if app.start_time!=nil && app.start_time.strftime('%H').to_i  == time
                  bool = false
                end
          end

          if bool
            list.push(time)
          end 

      time += duration

     if time > 11
        break
     end       
    end
    list
  end	
end
    
