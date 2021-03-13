class DataFetchWorker
  include Sidekiq::Worker

  def perform(*args)
    LocationUpdateJob.update_pa
  end
end
