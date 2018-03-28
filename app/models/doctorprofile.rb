class Doctorprofile < ActiveRecord::Base
	belongs_to :doctor ,class_name: User

   validates :duration, numericality: 
   { only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5 }
end
