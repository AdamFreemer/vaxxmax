class RiteAidMidAtlanticWorker
  include Sidekiq::Worker

  def perform
    LocationUpdateJob.update_locations_mid_atlantic
  end
end
