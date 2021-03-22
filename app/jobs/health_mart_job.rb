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
        request['Connection'] = 'keep-alive'
        request['Sec-Ch-Ua'] = '\"Google Chrome\";v=\"89\", \"Chromium\";v=\"89\", \";Not A Brand\";v=\"99\"'
        request['Accept'] = 'application/json, text/javascript, */*; q=0.01'
        request['X-Requested-With'] = 'XMLHttpRequest'
        request['Sec-Ch-Ua-Mobile'] = '?0'
        request['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36'
        request['Sec-Fetch-Site'] = 'same-origin'
        request['Sec-Fetch-Mode'] = 'cors'
        request['Sec-Fetch-Dest'] = 'empty'
        request['Referer'] = 'https://scrcxp.pdhi.com/Member/Home/Program/39d48d44-9969-4ab4-961e-aa08c9a38f08'
        request['Accept-Language'] = 'en-US,en;q=0.9,ca;q=0.8'
        request['Cookie'] = '__RequestVerificationToken=wWlneD0rE12l5HgLA9eZgJJUAqBmHaDb8SXAbaHOQW0WxdoRsJqhNG7dWfcptTk9W4mLQGyypCmxsjePwkUN4tivvHI1; XPCookie=FjFrOEXFfY_yZkQJQfm14yIubzTuCKg2SuKpWLOWhc9ja3uCmaUfvC45IQ3Wup1wLTMK-cYILRi8DIr4dwmkJ4zUpzJvlb6-wQgCVyAr1qsqveMvmg8JUR9XwrM79Hf4sJpMGk6uVu7yh3aVG3fh7oTBuV33sCmmV74n2b-Lfx3yvrHjxrD9XABubFMUh74XGdTo78LRhWyrp_TjIwAgU-_6VNpSBfqxmO7CExQ1UuaLbCxJ27YnPmfZ7vJkitVuMI7-Z2FG76-rfjJLGjmmlpsV1jjTrvyq_Bwntn2giCP0mHE5wHFl6ermnm12npy4YhP2xZcF1U5WfJcYMswTVY3uyDRwxv9za5u3KAYaF6UK53Sv4vjOwGhxMPN9tXPR5MlSfiYpdQG_bJXdtLZp2rAg_8Pu1GaLHlw3R_kGHHkKsCbovk5WysmBM8t_mhXWt9Zv-C9IoyRw-TdvMtkNm8t7uaJIBXCgufnE0aRoWJ-_tLhIUq1qHEelXMGA1Dk5R2yOdd41L142lh5hNLsY7jrXNnYGqAqB95p2WukJWcDqNOCXZVGJDQem80fuMyXcTDfyRhcdoRMyAF_OxW6dCCFqYI27a4GJdgo5C3kx9wOnKBnI'

        req_options = {
          use_ssl: uri.scheme == 'https'
        }

        begin
          response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
          end

          if response.body != "[]"
            location.last_updated = DateTime.now
            location.when_available = DateTime.now if location.availability.blank?
            location.availability = true
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
