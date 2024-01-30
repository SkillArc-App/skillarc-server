require 'pub_sub_initializer'

Rails.application.config.after_initialize do
  PubSubInitializer.run
end

if Rails.env.development?
  Rails.application.reloader.to_prepare do
    PubSubInitializer.run
  end
end
