class Note < ActiveRecord::Base
	belongs_to :appointment
	validates :description ,presence: true
end
