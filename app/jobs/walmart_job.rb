class WalmartJob
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
      locations = WalmartCity.where(state: state)
      locations.each do |location|
        require 'net/http'
        require 'uri'

        uri = URI.parse("https://www.walmart.com/pharmacy/v2/storefinder/stores/f69edd30-1305-4f94-88cd-9a121ed111be?searchString=#{location.zip}&serviceType=covid_immunizations&filterDistance=50")
        request = Net::HTTP::Get.new(uri)
        request.content_type = "application/json"
        request['Authority'] = 'www.walmart.com'
        request['Sec-Ch-Ua'] = '\"Google Chrome\";v=\"89\", \"Chromium\";v=\"89\", \";Not A Brand\";v=\"99\"'
        request['Sec-Ch-Ua-Mobile'] = '?0'
        request['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36'
        request['Wpharmacy-Source'] = 'web/chrome89.0.4389/OS X 10.15.7/f69edd30-1305-4f94-88cd-9a121ed111be'
        request['Accept'] = 'application/json'
        request['Wpharmacy-Trackingid'] = '016d8ab9-1830-468a-a6a4-cce0eef057f4'
        request['Rx-Electrode'] = 'true'
        request['Sec-Fetch-Site'] = 'same-origin'
        request['Sec-Fetch-Mode'] = 'cors'
        request['Sec-Fetch-Dest'] = 'empty'
        request['Referer'] = 'https://www.walmart.com/pharmacy/clinical-services/immunization/scheduled?imzType=covid&r=yes'
        request['Accept-Language'] = 'en-US,en;q=0.9,ca;q=0.8'
        request['Cookie'] = 'TB_Latency_Tracker_100=1; TB_Navigation_Preload_01=1; TB_DC_Flap_Test=0; vtc=aUM8oz1Pt8vxJGR2yLfg6A; bstc=aUM8oz1Pt8vxJGR2yLfg6A; mobileweb=0; xpa=4YbS0|Aa-Hd|FGkbO|GLQ0p|YkdjI|s-848|vZriO; exp-ck=4YbS01Aa-Hd1FGkbO1YkdjI1s-8481vZriO1; TS013ed49a=01538efd7c12ab687c12695e9b4dbb96f5907e7084fcf0d8eac1d1020070ee1a0f1db3abdf5308b6cdea6910127b59b15d598cf2b1; TBV=7; _abck=jcv9iff3eze99f8bsmiv_1881; TS01b0be75=01538efd7c12ab687c12695e9b4dbb96f5907e7084fcf0d8eac1d1020070ee1a0f1db3abdf5308b6cdea6910127b59b15d598cf2b1; _gcl_au=1.1.522627762.1616477167; _uetsid=44fca5808b9811eb9497f1ca5e4b57cc; _uetvid=44fcfdb08b9811eb9992bf8aaa5332c1; _fbp=fb.1.1616477167453.1904124641; viq=Walmart; tb_sw_supported=true; s_pers_2=+s_fid%3D78BD6FD850DA8C1B-20DB6C335A0517F8%7C1679549167158%3BuseVTC%3DY%7C1679592367; s_sess_2=%20s_cc%3Dtrue%3B; s_vi=[CS]v1|302CBDF82DC80BC6-60001E3FDD6EDA8A[CE]; _pxvid=4595dd62-8b98-11eb-8ef8-0242ac120010; wm_ul_plus=INACTIVE|1616563637214; auth=MTAyOTYyMDE4jQlcS%2BP7GAhp4bD0LATfmE4G7GDCtpv7l4KOxocRJHOLMKzmJSA5SLm73b0slW2wciS2rahrWy%2B5g93bwQ1vscc96NfNI6V%2FlddwKCGmWKNRzrJgdBvfjZ5x3zdiZ%2BZtYlDA5Hf6rT%2FsSqZXoWVicJ%2F961T6qeEI%2B5WfXN0eOyaW%2F2GKobEQQ6UhrqLZJk11wivYv09ujcW0mfJhJoSAsLRJFkYbLfL2voVNKbeCFCXnDsk2BGKaQ%2F%2FMvfHnksrx03Fv%2F9kf77b402zKuh2nfF7CgH0D8QE7t4cOdH2nDySdrQjP2z8TxguNAcMP%2BgEXN217zhfNJwE0OZI4fAJiu8tkaTC%2B3Tz%2BEfqY6ySAj%2FGEcDtJDRuA19tmIiJLIE7e; rtoken=MDgyNTUyMDE4XIzBi7jbvAqebYCgxZQqK7r78C0NNX2Cpa9KSdU1KHnhrhPhFjDA7xT73k2%2F8xhDiqwKIZ5%2BI%2FhKXrJWteg9%2Bhc%2Bp6l0lG24IGtiUcruDcbQjXKZpCEtkExc3McmBL1Yh%2BANp%2Ba1BWmVSLy08kG2Kp%2FxgiMspFL%2FCxdLd%2Bd3m%2FXKqW%2BbsOb9cwW%2Fa5y3sXYeD7S6Hp2%2Bq1fW%2FNK3oiW3Ll7%2Fj4iPu0T8v3Me1BUy7eMaU%2FV8%2BoZA8lbf3MNaQyoYGYnbrZ%2B%2FAiMsaig3UCxf3jeiy4xwwOC38a47B8%2BHEjStcsC7Xl9hqKafSeYpXMN%2FQF5AygsQie803IW5nfb8Zok1QspUSa1bzzzRIP7FYMs5%2BteeQHmnIw0MrKZQL7BJux8TBh7Ol4s24%2F9H9UlqFA%3D%3D; SPID=2d6db33c226a25372116e2f8ff6c29229dd1551ea736303e466b174a105d16c6afe0b459c96bb2372945f7de99f07289cprof; CID=f69edd30-1305-4f94-88cd-9a121ed111be; hasCID=1; customer=%7B%22firstName%22%3A%22Adam%22%2C%22lastNameInitial%22%3A%22F%22%2C%22rememberme%22%3Atrue%7D; type=REGISTERED; WMP=4; TB_SFOU-100=1; xpm=1%2B1616477237%2BaUM8oz1Pt8vxJGR2yLfg6A~f69edd30-1305-4f94-88cd-9a121ed111be%2B0; ACID=f69edd30-1305-4f94-88cd-9a121ed111be; next-day=1616533200|true|false|1616587200|1616477248; location-data=94066%3ASan%20Bruno%3ACA%3A%3A0%3A0|21k%3B%3B15.22%2C46y%3B%3B16.96%2C1kf%3B%3B19.87%2C1rc%3B%3B23.22%2C46q%3B%3B25.3%2C2nz%3B%3B25.4%2C2b1%3B%3B27.7%2C4bu%3B%3B28.38%2C2er%3B%3B29.12%2C1o1%3B%3B30.14|2|7|1|1xun%3B16%3B0%3B2.44%2C1xtf%3B16%3B1%3B4.42%2C1xwj%3B16%3B2%3B7.04%2C1ygu%3B16%3B3%3B8.47%2C1xwq%3B16%3B4%3B9.21; DL=94066%2C%2C%2Cip%2C94066%2C%2C; akavpau_p8=1616477848~id=e824d751ec022f3d2c1e15146421c070; TS011baee6=0130aff2320f030690ff7d7b3072dd5e45f03379fbc06aa3987c26d1cd51dbc259330df9cfda64f240d775b3d655111ff8cb3ba8d8; TS01e3f36f=0130aff2320f030690ff7d7b3072dd5e45f03379fbc06aa3987c26d1cd51dbc259330df9cfda64f240d775b3d655111ff8cb3ba8d8; TS018dc926=0130aff2320f030690ff7d7b3072dd5e45f03379fbc06aa3987c26d1cd51dbc259330df9cfda64f240d775b3d655111ff8cb3ba8d8; _px3=c7659f4b09dcfd1bb5062e59086489cfde7ab582e58d0663dccbd74b02f90b81:LV3HCeSTw3+exCMtMoR8YyTbKYs4EYbxzTL7SZg5CEIofAjyXoN06nEioDJ6Nd34r8m2fHaFReiLhHer85KGZg==:1000:rdOmqQ7TRUCEupCFHFhrRyHyKjph/lJ6Z1UDFK2NucYFnp46MUYWcnDZOkZ+8mgk5VDdm0tmwVv1MDgkg7uR7cu9Wb/GwTHJsC3ey5UUViHOXsxoEMZM/V7MsHxzWT8QYAM77RDpoeU4r1/HJVUPiFxOgOsKgSMl31hUCEZgNyY=; _pxde=d619e1bf53490306164aa5bd73a1269d8e0952525a3dca6c5865ed0c023d5714:eyJ0aW1lc3RhbXAiOjE2MTY0NzcyOTM5MzAsImZfa2IiOjAsImlwY19pZCI6W119; s_sess=%20ent%3DAccount%253ASignIn%3B%20cp%3DY%3B%20s_sq%3D%3B%20s_cc%3Dtrue%3B%20chan%3Dorg%3B%20v59%3DAccount%3B%20v54%3DAccount%253A%2520SignIn%3B%20cps%3D0%3B; s_pers=%20s_v%3DY%7C1616479095343%3B%20gpv_p11%3Dno%2520value%7C1616479095363%3B%20gpv_p44%3Dno%2520value%7C1616479095372%3B%20s_vs%3D1%7C1616479095378%3B%20s_fid%3D78BD6FD850DA8C1B-20DB6C335A0517F8%7C1679549299166%3B'

        req_options = {
          use_ssl: uri.scheme == 'https'
        }

        begin
          response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
          end
          parsed_response = JSON.parse(response.body)
          if parsed_response['status'] == "1"
            location.increment!(:appointments_all)
            location.increment!(:appointments) if location.availability.blank?
            location.last_updated = DateTime.now
            location.when_available = DateTime.now if location.availability.blank?
            location.availability = true
            History.create!(
              status: true,
              is_walmart: true,
              latitude: location&.latitude,
              longitude: location&.longitude,
              city: location&.name,
              state: location&.state,
              zip: location&.zip,
              last_updated: location&.last_updated,
              when_available: location&.when_available
            )            
          else
            location.availability = false
            location.last_updated = DateTime.now
          end
          location.save
        rescue StandardError => e
          location.availability = false
          location.last_updated = DateTime.now
          location.save
          puts "-- ERROR Walmart | #{location.id} | #{state} | #{location.city} \n Message: #{e}"
          next
        end
        puts "-- SUCCESS Walmart | #{location.availability} | #{state} | #{location.zip} | #{location.city}"
      end
    end
  end
end
