class Appointment < ActiveRecord::Base

	belongs_to :doctor  ,class_name: User
	belongs_to :patient ,class_name: User
	has_many :notes
	has_many :images ,as: :imageable

	validates :date ,presence: true
	validate :check_appointment_date

	enum status: [:pending,:completed,:cancelled]

  def check_appointment_date
    if  date < Date.today
      errors.add(:appointment_date, "can't be in the past")
    end
  end
	

end
