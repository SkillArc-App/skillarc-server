class TestJob
  @queue = :default

  def self.perform(i)
    puts "I'm doing a job #{i}!"
  end
end