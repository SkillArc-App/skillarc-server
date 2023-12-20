task :elapse_day => :environment do
  ElapseDayJob.perform
end
