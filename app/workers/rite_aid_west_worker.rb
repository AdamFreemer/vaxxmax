class RiteAidWestWorker
  include Sidekiq::Worker

  def perform
    LocationUpdateJob.update_locations_west
  end
end
