OmniAuth.config.logger = Rails.logger

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :facebook, '465165247233809', 'd3ce08d04358c575d240899a6c5af8da'
# 


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '504981975584-lo761bhm66hcri25br4mg9hcdjn6h153.apps.googleusercontent.com
', 'GgszwI6Xd66KuYYCIoKGefB6',
    {
      name: 'google',
      prompt: 'select_account'
    }  
end