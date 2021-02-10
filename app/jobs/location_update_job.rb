class LocationUpdateJob
  include Sidekiq::Worker

  def perform(args)
    @locations = Location.all
    @locations.each do |location|
      uri = URI("https://www.riteaid.com/services/ext/v2/vaccine/checkSlots?storeNumber=#{location.store_number}")
      @http = Net::HTTP::Persistent.new
      response = @http.request uri
      data = JSON.parse(response.body)
      puts "-- Location: #{location.id} - id: #{location.store_number} #{data}"

      location.status = data['Status']
      location.slot_1 = !(data['Data']['slots']['1'] == false)
      location.slot_2 = !(data['Data']['slots']['2'] == false)
      location.last_updated = DateTime.now
      location.save
      response.body
    end
    @http.shutdown
  end
end