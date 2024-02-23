require 'message_serializer'

Rails.application.config.active_job.custom_serializers << MessageSerializer
