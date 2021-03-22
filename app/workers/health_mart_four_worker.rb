class HealthMartFourWorker
  include Sidekiq::Worker

  def perform
    HealthMartJob.update_zone_4
  end
end
