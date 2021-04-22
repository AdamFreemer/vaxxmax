class HealthMartJob
  class << self
    def update_zone_1
      states = ['AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL']
      states.each do |state|
        update(state)
      end
    end

    def update_zone_2
      states = ['GA', 'GU', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA']
      states.each do |state|
        update(state)
      end
    end

    def update_zone_3
      states = ['MA', 'MD', 'ME', 'MI', 'MN', 'MO', 'MP', 'MS', 'MT', 'NC']
      states.each do |state|
        update(state)
      end
    end

    def update_zone_4
      states = ['ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR']
      states.each do |state|
        update(state)
      end
    end

    def update_zone_5
      states = ['PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VT', 'WA', 'WI', 'WV','WY']
      states.each do |state|
        update(state)
      end
    end

    def update(state)
      locations = HealthMartCity.where(state: state)
      locations.each do |location|
        require 'net/http'
        require 'uri'

        uri = URI.parse("https://scrcxp.pdhi.com/ScreeningEvent/fed87cd2-f120-48cc-b098-d72668838d8b/GetLocations/#{location.zip.to_s}?state=#{location.state.to_s}")
        request = Net::HTTP::Get.new(uri)
        request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:87.0) Gecko/20100101 Firefox/87.0"
        request["Accept"] = "application/json, text/javascript, */*; q=0.01"
        request["Accept-Language"] = "en-US,en;q=0.5"
        request["X-Requested-With"] = "XMLHttpRequest"
        request["Connection"] = "keep-alive"
        request["Referer"] = "https://scrcxp.pdhi.com/Member/Home/Program/39d48d44-9969-4ab4-961e-aa08c9a38f08"
        request["Cookie"] = "__RequestVerificationToken=TBVxt3WqBIHNEchFts1x9ueEwigR7HlVUGbKhMrF5is1IdvH2Zd1J9R9Ti75nsuvY52d_4FOMo-S4WrE2GZN7MSCr041; XPCookie=2wexWMOBbKt5Xi6YdQPqvcYC3unYaDzhGk7q23q90At6OYK1nb_ZMquP1wFSBGRTpr9uLd5woqk3VLsUCdMusBZ6c50aV834qagik07futu5mWfsjgQbqJp-QOMAc463qj_XFX52kvKUOEVzgHRasdUoVs_HSHGXckRPKR3sh0yncwtnTRJQffYU6FzO2QAlj26kWWCMbxpsOXhjmNVxejlhfHL3GQTLJJSAhuqvbNiRNO37SkX6I92-BAiJrw3GVjS0HblRg4WaLhkctIu25d8PDBVSngG6tVdtUV8LnEuFLE3Bod3G5Otf0DSuBtBajXbs6m0xF9DPmlTAXMH8xv6fVv2pnzjRnZVxSv5mrfH9Vz96jdKOXb4b8XOCxtGM_7LZXpoBAIIq3CwCYspEA4UY8H7XcWwv-oblP1qBxzZ552Es0xu5AQx_XfdFXrRuJE40kllCTjuGDfElJAdItaxbmhW95G6mRFQAY-jcA4o_VNMeEjh9SNGeeQegXFH0wm3WRWuEOboNQtqJIxFO5KbSMTT2KiKNcexFVRFcLOlctrmO8yfZ6rACm-ncPtuxdJ-QszYGYi3JJ82vRqarPO6WHG_7_uihaldI5ivp5uoqu8Da"
        request["Dnt"] = "1"
        request["Sec-Gpc"] = "1"

        req_options = {
          use_ssl: uri.scheme == 'https'
        }

        begin
          response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
          end
          
          if response.body != "[]"
            location.increment!(:appointments_all)
            location.increment!(:appointments) if location.availability.blank?
            location.last_updated = DateTime.now
            location.when_available = DateTime.now if location.availability.blank?
            location.availability = true
            # History.create!(
            #   location_id: location.id,
            #   status: true,
            #   is_health_mart: true,
            #   latitude: location&.latitude,
            #   longitude: location&.longitude,
            #   city: location&.name,
            #   state: location&.state,
            #   zip: location&.zip,
            #   last_updated: location&.last_updated,
            #   when_available: location&.when_available
            # )            
          else
            location.availability = false
            location.last_updated = DateTime.now
          end
          location.save
        rescue StandardError => e
          location.availability = false
          location.last_updated = DateTime.now
          location.save
          puts "-- ERROR HealthMart | #{location.id} | #{state} | #{location.name} \n Message: #{e}"
          next
        end
        puts "-- SUCCESS HealthMart | #{location.availability} | #{state} | #{location.name} | #{location.zip}"
      end
    end
  end
end
