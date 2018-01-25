class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :doctor_appointments  , foreign_key: :doctor_id ,  class_name: Appointment       
  has_many :patient_appointments , foreign_key: :patient_id , class_name: Appointment

  has_many :patients, through: :doctor_appointments
  has_many :doctors,  through: :patient_appointments

  has_one :image ,as: :imageable

  enum role: [:doctor,:patient]

  #Validations
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates_format_of :email, :with => EMAIL_REGEX , message: "Please enter a valid email id" 
  validates :first_name ,presence: true

  def appointment_list
      if self.doctor?
        @list = self.doctor_appointments.where(["date >= ?" ,DateTime.now]).order(:date)
      else
        @list = self.patient_appointments.where(["date >= ?" ,DateTime.now]).order(:date)
      end 

      @list
  end 

end
