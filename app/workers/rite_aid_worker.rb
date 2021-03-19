class RiteAidWorker
  include Sidekiq::Worker

  def perform(state)
    locations = Location.where(state: state, is_rite_aid: true)
    locations.each_with_index do |location|
      uri = URI("https://www.riteaid.com/services/ext/v2/vaccine/checkSlots?storeNumber=#{location.store_number}")
      @http = Net::HTTP::Persistent.new

      begin
        response = @http.request uri
        data = JSON.parse(response.body)
      rescue StandardError => e
        puts "-- ERROR Rite Aid | #{state} | #{location.city} | #{location.store_number}"
        data = nil
        next
      end
      puts "-- SUCCESS Rite Aid | #{data['Data']['slots']['1']} | #{state} | id: #{location.id} | store: #{location.store_number}"

      if data['Data'].nil?
        puts "-- ERROR Rite Aid | ID: #{location.id} | Store: #{location.store_number}"
        next
      end

      location.status = data['Status']
      location.slot_1 = !(data['Data']['slots']['1'] == false)
      location.slot_2 = !(data['Data']['slots']['2'] == false)
      location.last_updated = DateTime.now
      if location.slot_1 || location.slot_2
        location.when_available = DateTime.now if location.availability.blank?
        # location.store_availability_count += 1 if location.availability.blank?
        location.availability = true
      else
        location.availability = false
      end
      location.save
      response.body
    end
    @http.shutdown
    puts "-- COMPLETED Update Job | State: #{state} --------"
  end
end
