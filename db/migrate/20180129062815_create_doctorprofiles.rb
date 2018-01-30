class CreateDoctorprofiles < ActiveRecord::Migration
  def change
    create_table :doctorprofiles do |t|
      t.integer :doctor_id
      t.time :appointment_duration
      t.integer :experience

      t.timestamps null: false
    end
  end
end
