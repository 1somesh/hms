class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.integer :appointment_id
      t.time :start_time
      t.time :finish_time
      t.date :appointment_date
      t.integer :doctor_id

      t.timestamps null: false
    end
  end
end
