require 'barnes'

Resque.before_fork do |_job|
  Barnes.start
end
