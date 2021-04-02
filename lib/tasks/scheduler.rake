# lib/tasks/scheduler.rake desc "tweets to twitter.com/blockwork_cc"
task update_cvs: :environment do
  LocationUpdateJob.update_cvs
  puts "cvs updated!"
end

# Rite Aid

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

# Health Mart

task health_mart_1: :environment do
  HealthMartJob.update_zone_1
  puts "Start HealthMart 1!"
end

task health_mart_2: :environment do
  HealthMartJob.update_zone_2
  puts "Start HealthMart 2!"
end

task health_mart_3: :environment do
  HealthMartJob.update_zone_3
  puts "Start HealthMart 3!"
end

task health_mart_4: :environment do
  HealthMartJob.update_zone_4
  puts "Start HealthMart 4!"
end

task health_mart_5: :environment do
  HealthMartJob.update_zone_5
  puts "Start HealthMart 5!"
end

# Walgreens API fetch

task walgreens_vspotter: :environment do
  WalgreensJob.process
  puts "Process Walgreens from vspotter..."
end

# Walmart

task walmart_1: :environment do
  WalmartJob.update_zone_1
  puts "Start Walmart 1!"
end

task walmart_2: :environment do
  WalmartJob.update_zone_2
  puts "Start Walmart 2!"
end

task walmart_3: :environment do
  WalmartJob.update_zone_3
  puts "Start Walmart 3!"
end

task walmart_4: :environment do
  WalmartJob.update_zone_4
  puts "Start Walmart 4!"
end

task walmart_5: :environment do
  WalmartJob.update_zone_5
  puts "Start Walmart 5!"
end

# Walgreens API fetch

task walmart_vspotter: :environment do
  WalmartJob.process
  puts "Process Walmart from vspotter..."
end