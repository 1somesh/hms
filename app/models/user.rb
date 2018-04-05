class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2, :twitter]

  scope :get_doctors_list, -> {doctor}      

  has_many :doctor_appointments, foreign_key: :doctor_id ,  class_name: :Appointment       
  has_many :patient_appointments, foreign_key: :patient_id , class_name: :Appointment

  has_many :patients, through: :doctor_appointments
  has_many :doctors,  through: :patient_appointments

  has_one :image, as: :imageable
  
  has_one :doctor_profile, foreign_key: :doctor_id, class_name: :Doctorprofile, dependent: :destroy
  
  enum role: [:doctor, :patient]
  attr_accessor :duration

  validates :first_name, presence: true

  def future_appointment_list      
      if self.doctor?
          @list = Appointment.includes(:patient).where(["date > ? AND doctor_id = ?" ,Time.now.strftime("%Y-%m-%d"),
          self.id]).order(:date).pending
      else
          @list = Appointment.includes(:doctor).where(["date > ? AND patient_id = ?" ,Time.now.strftime("%Y-%m-%d"),
          self.id]).order(:date).pending
      end
  end 
 
  def past_appointment_list
      if self.doctor?
          @list = Appointment.includes(:patient).where(doctor_id: self.id).where(["date <= ? OR status!= ?" ,
          Date.today, "pending"]).order(:date)
      else
          @list = Appointment.includes(:doctor).where(patient_id: self.id).where(["date <= ? OR status!= ?" ,
          Date.today, "pending"]).order(:date)
      end  
  end 

  # def initialize_image(image)
  #   if Image.new(image: image).valid?
  #     self.image =  Image.new(image: image)
  #   end  
  # end  



  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data['email']).first
      unless user
        user = User.create(first_name: data['name'], email: data['email'], password: Devise.friendly_token[0,20])
      end
      user.skip_confirmation!
      user
  end

  #override
  def password_required?
      super && provider.blank?
  end

  #override
  def email_required?
      super && provider.blank?
  end

end


      