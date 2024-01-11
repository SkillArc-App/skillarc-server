task elapse_day: :environment do
  ElapseDayJob.perform_later
end
