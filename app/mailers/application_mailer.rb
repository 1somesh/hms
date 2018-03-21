class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.COMPANY_EMAIL
  layout false
end
