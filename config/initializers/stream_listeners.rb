require 'pub_sub_initializer'
require 'pubsub'

PUBSUB = Pubsub.new
PUBSUB_SYNC = Pubsub.new

Rails.application.config.after_initialize do
  PubSubInitializer.run
end

if Rails.env.development?
  Rails.application.reloader.to_prepare do
    PubSubInitializer.run
  end
end
