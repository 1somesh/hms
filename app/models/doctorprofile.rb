class Doctorprofile < ActiveRecord::Base
	belongs_to :doctor ,class_name: User

	validates :appointment_duration, numericality: {less_than_or_equal_to: 5, greater_than: 0}

end
