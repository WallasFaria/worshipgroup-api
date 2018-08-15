Devise.setup do |config|
  config.secret_key = MyApp::Application.config.secret_key_base || ENV['SECRET_KEY_BASE']
end
