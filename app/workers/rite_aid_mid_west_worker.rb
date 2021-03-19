class RiteAidMidWestWorker
  include Sidekiq::Worker

  def perform
    LocationUpdateJob.update_locations_midwest
  end
end
