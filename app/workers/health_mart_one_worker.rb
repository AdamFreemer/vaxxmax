class HealthMartOneWorker
  include Sidekiq::Worker

  def perform
    HealthMartJob.update_zone_1
  end
end
