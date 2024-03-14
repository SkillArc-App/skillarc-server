module CommandEmitter
  private

  def with_command_service(command_service = CommandService.new)
    Thread.current.thread_variable_set(:command_service, command_service)
    yield
  ensure
    command_service.flush

    Thread.current.thread_variable_set(:command_service, nil)
  end

  def command_service
    Thread.current.thread_variable_get(:command_service)
  end
end
