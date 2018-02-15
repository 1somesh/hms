class ExpiredDateWorker
  include Sidekiq::Worker

  def perform(*args)
     appointment = Appointment.find args[0]  
     	if !appointment.cancelled?
    		appointment.completed!
   		    expire_page '/appointments'
    	end	 
  end

end
