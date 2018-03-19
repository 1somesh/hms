# require 'rake'
namespace :qwerty do
	desc "gives a list of first names of all the users"
	task :mytask => :environment do
		User.all.each do |a|
			puts a.first_name
		end	
	end
end	
