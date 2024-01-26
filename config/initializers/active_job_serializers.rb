require 'events/message_serializer'

Rails.application.config.active_job.custom_serializers << Events::MessageSerializer
