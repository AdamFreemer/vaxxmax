# lib/tasks/scheduler.rake desc "tweets to twitter.com/blockwork_cc"
task update_locations_north_east: :environment do
  LocationUpdateJob.update_locations_north_east
  puts "locations north_west updated!"
end

task update_locations_mid_atlantic: :environment do
  LocationUpdateJob.update_locations_mid_atlantic
  puts "locations mid_atlantic updated!"
end

task update_locations_west: :environment do
  LocationUpdateJob.update_locations_west
  puts "locations west updated!"
end

task update_locations_north_west: :environment do
  LocationUpdateJob.update_locations_north_west
  puts "locations north_west updated!"
end

task update_locations_midwest: :environment do
  LocationUpdateJob.update_locations_midwest
  puts "locations midwest updated!"
end
