class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2, :twitter]

  scope :get_doctors_list, -> {all.doctor}      

  has_many :doctor_appointments  , foreign_key: :doctor_id ,  class_name: Appointment       
  has_many :patient_appointments , foreign_key: :patient_id , class_name: Appointment

  has_many :patients, through: :doctor_appointments
  has_many :doctors,  through: :patient_appointments

  has_one :image, as: :imageable
  
  has_one :doctor_profile ,foreign_key: :doctor_id, class_name: 'Doctorprofile' ,dependent: :destroy
  enum role: [:doctor,:patient]
  attr_accessor :duration

  validates :first_name, presence: true
  # validates :email, uniqueness: true, if: 'provider.blank?'   

  #returns the list of future appointments of user
  def future_appointment_list
      if self.doctor?
        @list = Appointment.includes(:patient).where(doctor_id: self.id).where(["date > ?" ,Time.now.strftime("%Y-%m-%d")]).where(status: "pending").order(:date)
      else
        @list = Appointment.includes(:doctor).where(patient_id: self.id).where(["date > ?" ,Time.now.strftime("%Y-%m-%d")]).where(status: "pending").order(:date)
      end 
      @list
  end 
 
  #returns the list of archived appointments of user both (completed and cancelled)
  def past_appointment_list
      if self.doctor?
        @list = Appointment.includes(:patient).where(doctor_id: self.id).where(["date <= ? OR status!= ?" ,Date.today ,"pending"]).order(:date)
      else
        @list = Appointment.includes(:doctor).where(patient_id: self.id).where(["date <= ? OR status!= ?" ,Date.today, "pending"]).order(:date)
      end  
  end 

  def create_image(image)
    self.image = Image.new(image: image)
  end  


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.first_name = auth.info.name
        user.email = auth.extra.raw_info.email
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.skip_confirmation! 
        user.save!
    end
  end

  def self.create_with_omniauth(auth)
      create! do |user|
          user.provider = auth["provider"]
          user.uid = auth["uid"]
          #user.email = auth["uid"]+"@a.com"
          user.first_name = auth["info"]["name"]
          user.skip_confirmation! 
      end
  end

  def password_required?
      super && provider.blank?
  end


  def email_required?
      super && provider.blank?
  end

end
