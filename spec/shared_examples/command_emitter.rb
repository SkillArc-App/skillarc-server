RSpec.shared_context "command emitter" do |flush|
  around do |ex|
    flush = true if flush.nil?

    command_service = CommandService.new

    Thread.current.thread_variable_set(:command_service, command_service)

    ex.run

    command_service.flush if flush

    Thread.current.thread_variable_set(:command_service, nil)
  end
end
