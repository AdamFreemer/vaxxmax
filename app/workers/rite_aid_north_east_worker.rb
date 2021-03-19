class RiteAidNorthEastWorker
  include Sidekiq::Worker

  def perform
    LocationUpdateJob.update_locations_north_east
  end
end
