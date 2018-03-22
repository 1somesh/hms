namespace :hms do
	desc "Notifies all the doctors to complete their profile."
	task :profile_updater => :environment do |t|
		 User.doctor do |doctor|
		 	if doctor.doctorprofile.experience.nil?
	 			HospitalManagementMailer.notify(doctor,"Complete your profile.","Hello #{doctor.first_name}, you should complete your profile 
	 			.So that your patients can entract with you in better ways...").deliver
	 			puts doctor.first_name
	 		end	
		 end	
	end
end	