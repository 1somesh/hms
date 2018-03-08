OmniAuth.config.logger = Rails.logger

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :facebook, '465165247233809', 'd3ce08d04358c575d240899a6c5af8da'
# 


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '504981975584-2atl8dalpjvd2l9ub0iub0ijpve34hkr.apps.googleusercontent.com
', 'OBH94v0gxEFQ_9LEfkZEnJ_o', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end