module CommandEmitter
  private

  def command_service
    @command_service ||= CommandService.new
  end
end
