class AddStartTimeToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :start_time, :time
  end
end
