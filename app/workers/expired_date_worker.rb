class ExpiredDateWorker
  include Sidekiq::Worker
  #sidekiq_options retry: false

  def perform(*args)
     appointment = Appointment.find args[0]
     appointment.update(status: 2)
  end

end
