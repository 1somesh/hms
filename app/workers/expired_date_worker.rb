class ExpiredDateWorker
  include Sidekiq::Worker
  #sidekiq_options retry: false

  def perform(*args)
     appointment = Appointment.find args[0]  
     	if !appointment.cancelled?
    		appointment.update(status: 1)
    	end	 
  end

end
