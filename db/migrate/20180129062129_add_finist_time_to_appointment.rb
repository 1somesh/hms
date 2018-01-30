class AddFinistTimeToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :finish_time, :time
  end
end
