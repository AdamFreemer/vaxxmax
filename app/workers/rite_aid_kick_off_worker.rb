class RiteAidKickOffWorker
  include Sidekiq::Worker

  def rite_aid_states
    ['NY', 'NJ', 'CT', 'MA', 'NH', 'VT', 'PA', 'DE', 'MD', 'CA', 'NV', 'WA', 'ID', 'OR', 'OH', 'MI', 'VA']
  end

  def perform
    rite_aid_states.each do |state|
      begin
        RiteAidWorker.perform_async(state)
      rescue StandardError => e
        puts "-- FAILURE | Rite Aid | #{state} | #{e}"
      end
    end
  end
end
