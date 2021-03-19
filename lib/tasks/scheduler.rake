# lib/tasks/scheduler.rake desc "tweets to twitter.com/blockwork_cc"
task update_cvs: :environment do
  LocationUpdateJob.update_cvs
  puts "cvs updated!"
end

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

task update_pa: :environment do
  LocationUpdateJob.update_pa
  puts "locations in pa updated!"
end

## walgreens

task update_walgreens_1: :environment do
  LocationUpdateJob.update_walgreens_1
  puts "Walgreens 1 updated!"
end

task update_walgreens_2: :environment do
  LocationUpdateJob.update_walgreens_2
  puts "Walgreens 2 updated!"
end

task update_walgreens_3: :environment do
  LocationUpdateJob.update_walgreens_3
  puts "Walgreens 3 updated!"
end


task update_walgreens_4: :environment do
  LocationUpdateJob.update_walgreens_4
  puts "Walgreens 4 updated!"
end

task update_walgreens_5: :environment do
  LocationUpdateJob.update_walgreens_5
  puts "Walgreens 4 updated!"
end

## Sidekiq RiteAid

task rite_aid_north_east: :environment do
  RiteAidNorthEastWorker.perform_async
  puts "locations north_west updated!"
end

task rite_aid_mid_atlantic: :environment do
  RiteAidMidAtlanticWorker.perform_async
  puts "locations mid_atlantic updated!"
end

task rite_aid_west: :environment do
  RiteAidWestWorker.perform_async
  puts "locations west updated!"
end

task rite_aid_north_west: :environment do
  RiteAidNorthWestWorker.perform_async
  puts "locations north_west updated!"
end

task rite_aid_mid_west: :environment do
  RiteAidMidWestWorker.perform_async
  puts "locations midwest updated!"
end
