class HealthMartTwoWorker
  include Sidekiq::Worker

  def perform
    HealthMartJob.update_zone_2
  end
end
