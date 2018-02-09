require 'rake'
task :mytask => :environment do
	User.all.each do |a|
		puts a.first_name
	end	

	User.first.update(first_name: "gh")
end	
