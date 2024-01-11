require 'event_message_serializer'

Rails.application.config.active_job.custom_serializers << EventMessageSerializer
