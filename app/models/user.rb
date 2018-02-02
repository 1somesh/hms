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

  has_one :doctor_profile ,foreign_key: :doctor_id, class_name: 'Doctorprofile'
  enum role: [:doctor,:patient]

  #Validations
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates_format_of :email, :with => EMAIL_REGEX , message: "Please enter a valid email id" 
  validates :first_name ,presence: true

  def future_appointment_list
      if self.doctor?
        @list = Appointment.includes(:patient).where(doctor_id: self.id).where(["date >= ?" ,Time.now.strftime("%Y-%m-%d")]).order(:date)
      else
        @list = Appointment.includes(:doctor).where(patient_id: self.id).where(["date >= ?" ,Time.now.strftime("%Y-%m-%d")]).order(:date)
      end 

      @list
  end 
 

  def past_appointment_list
      @list = Appointment.includes(:patient).where(doctor_id: self.id).where(["date < ?" ,DateTime.now]).order(:date)
  end 

  def create_image(image)
    self.image = Image.new(image: image)
  end  

  def self.get_doctors_list
    User.where(role: "doctor")
  end
end
