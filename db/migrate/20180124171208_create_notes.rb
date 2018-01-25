class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :description
      t.integer :user_id
      t.integer :appointment_id

      t.timestamps null: false
    end
  end
end
