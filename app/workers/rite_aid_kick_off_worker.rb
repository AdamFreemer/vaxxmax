class RiteAidKickOffWorker
  include Sidekiq::Worker

  def rite_aid_states
    ['NY', 'NJ', 'CT', 'MA', 'NH', 'VT', 'PA', 'DE', 'MD', 'CA', 'NV', 'WA', 'ID', 'OR', 'OH', 'MI', 'VA']
  end

  def perform
    rite_aid_states.each do |state|
      RiteAidWorker.perform_async(state)
    end
  end
end
