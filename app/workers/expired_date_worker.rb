class ExpiredDateWorker
  include Sidekiq::Worker

  def perform(*args)
     appointment = Appointment.find args[0]  
     	if !appointment.cancelled?
    		appointment.update(status: "completed")
    	end	 
  end

end
