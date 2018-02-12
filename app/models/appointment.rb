class Appointment < ActiveRecord::Base

	belongs_to :doctor  ,class_name: User
	belongs_to :patient ,class_name: User
	has_many :notes
	has_many :images ,as: :imageable

	validate :start_time_present?
	validate :check_appointment_date
	#validates_associated :notes

	enum status: [:pending,:completed,:cancelled]
	attr_accessor :note

  def start_time_present?
    if start_time.blank?
      errors.add('start_time',"Please select appointment time")
    end
  end  

  def check_appointment_date
    if  date  < Date.today
      errors.add(:appointment_date, "can't be in the past")
    end
  end

  def initialize_note(user_id,note)
  	self.notes.new(user_id: user_id, description: note)
  end


  def self.update_worker(appointment,start_time,duration)
      queue = Sidekiq::ScheduledSet.new
      queue.each do |job| 
          if job.args[0].to_i == appointment.id
            current_job = Sidekiq::ScheduledSet.new.find_job(job.jid)
            current_job.reschedule (appointment.date + (duration.strftime("%H").to_i + start_time.to_i)*60*60+7*3600)
          end  
      end    
  end

  def self.get_booked_slots(doctor_id,selected_date)

    duration = Doctorprofile.where(doctor_id: doctor_id).first.appointment_duration.strftime("%H").to_i
    appointments = Appointment.where(doctor_id: doctor_id,date: selected_date).where("status != ?",2) 
    list = []

    time = 5
    loop do 

          bool = true
          appointments.each do |app|
                if app.start_time.strftime('%H').to_i  == time
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
    