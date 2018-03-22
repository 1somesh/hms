class ExpiredDateWorker
  include Sidekiq::Worker
  #default queue is used as
  #only one type of task is to be performed

  #Mark the appointment as completed is it isn't yet cancelled
  def perform(*args)
     appointment = Appointment.find_by(id: args[0])  
     	if !appointment.cancelled?
    		appointment.completed!
   		    expire_page '/appointments'
    	end	 
  end

end
