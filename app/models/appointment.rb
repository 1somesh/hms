class Appointment < ActiveRecord::Base

	belongs_to :doctor  ,class_name: User
	belongs_to :patient ,class_name: User
	has_many :notes
	has_many :images ,as: :imageable

	validate :start_time_present?
	validate :check_appointment_date

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

  def update_worker(start_time,duration)
      queue = Sidekiq::ScheduledSet.new
      queue.each do |job| 
          if job.args[0].to_i == self.id
            current_job = Sidekiq::ScheduledSet.new.find_job(job.jid)
            current_job.reschedule (self.date + (duration.strftime("%H").to_i + start_time.to_i)*60*60)
          end  
      end    
  end



  def initialize_note(user_id,note)
  	self.notes.new(user_id: user_id, description: note)
  end


  def get_appointment_duration(start_time)
    duration = self.doctor.doctor_profile.appointment_duration
    self.finish_time = (start_time.to_time + duration.to_i).strftime("%H:%M:%S").to_time.strftime("%H:%M:%S") if start_time.present?
    duration
  end


  def create_image(image)
    self.images.create(image: image) if !image.blank?
  end


  def self.get_new_date(date)
    new_date = "#{date["date(1i)"]}-#{date["date(2i)"]}-#{date["date(3i)"]}"
    new_date.to_date
  end


  def self.get_booked_slots(doctor_id,selected_date)

    duration = Doctorprofile.find_by(doctor_id: doctor_id).appointment_duration.strftime("%H").to_i
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
    