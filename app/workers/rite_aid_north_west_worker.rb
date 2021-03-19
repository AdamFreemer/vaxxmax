class RiteAidNorthWestWorker
  include Sidekiq::Worker

  def perform
    LocationUpdateJob.update_locations_north_west
  end
end
