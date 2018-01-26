class Appointment < ActiveRecord::Base

	belongs_to :doctor  ,class_name: User
	belongs_to :patient ,class_name: User
	has_many :notes
	has_many :images ,as: :imageable

	validates :date ,presence: true
	validate :check_appointment_date
	validates_associated :notes

	enum status: [:pending,:completed,:cancelled]
	attr_accessor :note


  def check_appointment_date
    if  date < Date.today
      errors.add(:appointment_date, "can't be in the past")
    end
  end

  def create_note(user_id,note)
  	self.notes.new(user_id: user_id, description: note)
  end	

end
