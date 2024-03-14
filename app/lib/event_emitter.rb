module EventEmitter
  private

  def with_event_service(event_service = EventService.new)
    Thread.current.thread_variable_set(:event_service, event_service)
    yield
  ensure
    event_service.flush

    Thread.current.thread_variable_set(:event_service, nil)
  end

  def event_service
    Thread.current.thread_variable_get(:event_service)
  end
end
