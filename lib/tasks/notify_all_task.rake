# require 'rake'
namespace :hms do
	desc "Sends an email to all users with given subjet and description."
	task :notify_all, [:subject,:description] => :environment do |t,args|
		 User.all.each do |u|
	 		HospitalManagementMailer.notify(u,args.subject,args.description).deliver
		 end	
	end
end	
