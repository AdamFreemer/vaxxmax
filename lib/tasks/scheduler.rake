# lib/tasks/scheduler.rake desc "tweets to twitter.com/blockwork_cc"
task update_locations: :environment do
  puts "Updating locations..."
  LocationUpdateJob.perform
  puts "locations updated!"
end