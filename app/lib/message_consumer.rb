class MessageConsumer
  NotSchemaError = Class.new(StandardError)
  NotActiveSchemaError = Class.new(StandardError)
  NotValidSubscriberType = Class.new(StandardError)

  def initialize(message_service: nil)
    @message_service = message_service
  end

  attr_writer :message_service

  def call(message:)
    handle_message(message)
  end

  def handle_message(message, now: Time.zone.now) # rubocop:disable Lint/UnusedMethodArgument
    schema = message.schema
    method_name = "#{schema.message_type}_#{schema.version}".to_sym
    return unless respond_to? method_name

    send(method_name, message)
  end

  def all_handled_messages
    handled_messages + handled_messages_sync
  end

  def self.on_message(schema, subscribe_type = :async, &)
    raise NotSchemaError unless schema.is_a?(Messages::Schema)
    raise NotActiveSchemaError if schema.inactive?
    raise NotValidSubscriberType unless subscribe_type.in?(%i[async sync])

    Rails.logger.error { "#{name} is subscribed to deprecated message #{schema}" } if schema.deprecated?

    if subscribe_type == :sync
      handled_messages_sync << schema
    else
      handled_messages << schema
    end

    method_name = "#{schema.message_type}_#{schema.version}".to_sym
    define_method(method_name, &)
  end

  def handled_messages
    self.class.handled_messages
  end

  def handled_messages_sync
    self.class.handled_messages_sync
  end

  def reset_for_replay
    raise NoMethodError
  end

  def self.handled_messages
    @handled_messages ||= []
  end

  def self.handled_messages_sync
    @handled_messages_sync ||= []
  end

  private

  attr_reader :message_service
end
