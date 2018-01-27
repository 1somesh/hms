# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

(1..10).each do |i|

	slot_data = {
		:appointment_id => rand(1...10),
		:start_time => ,
		:doctor_id => 3
	}

	slot = Slot.new(slot_data)
	slot.save
end
