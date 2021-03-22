class HealthMartThreeWorker
  include Sidekiq::Worker

  def perform
    HealthMartJob.update_zone_3
  end
end
