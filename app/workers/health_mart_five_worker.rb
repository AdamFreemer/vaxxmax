class HealthMartFiveWorker
  include Sidekiq::Worker

  def perform
    HealthMartJob.update_zone_5
  end
end
