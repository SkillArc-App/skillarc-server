RSpec.shared_context "event emitter" do |flush|
  around do |ex|
    flush = true if flush.nil?

    event_service = EventService.new

    Thread.current.thread_variable_set(:event_service, event_service)

    ex.run

    event_service.flush if flush

    Thread.current.thread_variable_set(:event_service, nil)
  end
end
