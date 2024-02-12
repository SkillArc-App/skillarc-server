require 'pub_sub_initializer'
require 'pubsub'

PUBSUB = Pubsub.new(sync: false)
PUBSUB_SYNC = Pubsub.new(sync: true)

Rails.application.config.after_initialize do
  PubSubInitializer.run
end

if Rails.env.development?
  Rails.application.reloader.to_prepare do
    PubSubInitializer.run
  end
end
