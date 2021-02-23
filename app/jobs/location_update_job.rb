class LocationUpdateJob
  class << self
    # CA, CT, DE, ID, MA, MD, MI, NH, NJ, NV, NY, OH, OR, PA, VA, VT, WA
    def update_locations_north_east
      rite_aid_update('NY')
      rite_aid_update('NJ')
      rite_aid_update('CT')
      rite_aid_update('MA')
      rite_aid_update('NH')
      rite_aid_update('VT')
      UpdateLog.create(task: 'update_locations_north_east')
    end

    def update_locations_mid_atlantic
      rite_aid_update('PA')
      rite_aid_update('DE')
      rite_aid_update('MD')
      UpdateLog.create(task: 'update_locations_mid_atlantic')
    end

    def update_locations_west
      rite_aid_update('CA')
      rite_aid_update('NV')
      UpdateLog.create(task: 'update_locations_west')
    end

    def update_locations_north_west
      rite_aid_update('WA')
      rite_aid_update('ID')
      rite_aid_update('OR')
      UpdateLog.create(task: 'update_locations_north_west')
    end

    def update_locations_midwest
      rite_aid_update('OH')
      rite_aid_update('MI')
      rite_aid_update('VA')
      UpdateLog.create(task: 'update_locations_midwest')
    end

    def update_walgreens_1
      states = ["AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL"]
      states.each do |state|
        walgreens_update(state)
      end
    end

    def update_walgreens_2
      states = ["GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "NY"]
      states.each do |state|
        walgreens_update(state)
      end
    end

    def update_walgreens_3
      states = ["MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE"]
      states.each do |state|
        walgreens_update(state)
      end
    end

    def update_walgreens_4
      states = ["NH", "NJ", "NM", "NV", "OH", "OK", "OR", "PA", "PR"]
      states.each do |state|
        walgreens_update(state)
      end
    end

    def update_walgreens_5
      states = ["RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"]
      states.each do |state|
        walgreens_update(state)
      end
    end

    def rite_aid_update(state)
      @locations = Location.where(state: state, is_rite_aid: true)
      @locations.each_with_index do |location, i|
        sleep(3) if i.to_s.include? '99'
        uri = URI("https://www.riteaid.com/services/ext/v2/vaccine/checkSlots?storeNumber=#{location.store_number}")
        @http = Net::HTTP::Persistent.new

        begin
          response = @http.request uri
          data = JSON.parse(response.body)
        rescue StandardError => e
          puts "-- ERROR JSON.parse or Net:HTTP | State: #{state} - Location ID: #{location.id} -- Message: #{e}"
          data = nil
          UpdateLog.create(task: "-- ERROR #{location.id} - store #: #{location.store_number} #{data}")
          next
        end
        puts "-- Index: #{i} - State: #{state} - Location ID: #{location.id} - store #: #{location.store_number} #{data}"

        if data['Data'].nil?
          puts "-- ERROR Rite Aid   : Location ID: #{location.id} - store #: #{location.store_number} #{data}"
          UpdateLog.create(task: "-- ERROR #{location.id} - store #: #{location.store_number} #{data}")
          next
        end
        location.status = data['Status']
        location.slot_1 = !(data['Data']['slots']['1'] == false)
        location.slot_2 = !(data['Data']['slots']['2'] == false)
        location.last_updated = DateTime.now
        if location.slot_1 || location.slot_2
          location.when_available = DateTime.now if location.availability.blank?
          location.store_availability_count += 1 if location.availability.blank?
          location.availability = true
        else
          location.availability = false
        end
        location.save
        response.body
      end
      @http.shutdown
      puts "-- COMPLETED Update Job | State: #{state}"
    end

    def walgreens_update(state) 
      puts "-- Starting Walgreens update for state: #{state}"

      locations = WalgreensCity.where(state: state)
      locations.each do |location|
        jsonbody = {
          serviceId: '99',
          position: {
            latitude: location.latitude.to_f,
            longitude: location.longitude.to_f
          },
          appointmentAvailability: { 
            startDateTime: Date.today.strftime("%Y-%m-%e")
          }, radius: 25
        }

        cookie = 'mt.v=2.1108819582.1613442906571; s_ecid=MCMID%7C29727988549706635071918356247855608635; Adaptive=true; USER_LOC="sQbCfOufHNGFx6h5dD3cOuSTTri1Eu3n/l2+Qp64phEuTp5Qw1KQCbbJ33dnyUd88DrsuW+EePT1z3L2oLwqPi068zLyRwmyU8nEG735dSdxb8qzyNU85qImb5m/brR0Sk0jg2i2PJRg8N3+MwSpMRI97u1U2aTgk0JQhimXDfzEGXpahUB0ea5nFSozr9o8WhDw0yFvRYr2zxWDVV1JPOqeQZz/NZ/uPaSvRsJ6oEI="; _gcl_au=1.1.1329235556.1613442933; liveagent_oref=https://www.walgreens.com/login.jsp?ru=%2Ffindcare%2Fvaccination%2Fcovid-19%2Feligibility-survey%3Fflow%3Dcovidvaccine%26register%3Drx; liveagent_ptid=b2549530-febf-4f40-9dc4-792a6473eb56; encLoyaltyId=MgCBb8QiTRr8/UwemeZrfg==; 3s=xJnEt8SDxaBpxYHFgcWnccOYxIRG; FirstName=Adam; 2fa=7d5083e2916cf3428663a5291bef9790; liveagent_vc=4; _uetvid=eb324820700b11eb86a82f5c6f758fac; _gcl_aw=GCL.1613614241.CjwKCAiAmrOBBhA0EiwArn3mfHsTm5mGG9OnQZqD4gJr_NTXwSEWIQe-V4ig_VsoFlsz0L6ZTE-1eBoCBccQAvD_BwE; _gcl_dc=GCL.1613614241.CjwKCAiAmrOBBhA0EiwArn3mfHsTm5mGG9OnQZqD4gJr_NTXwSEWIQe-V4ig_VsoFlsz0L6ZTE-1eBoCBccQAvD_BwE; _4c_=%7B%22_4c_s_%22%3A%22jVNNT%2BMwEP0rKAdOpLGdDzuV0KoUkFhtWyiIPUZOMk28tHHWdpsW1P%2BO0wTa5bAil8y8ee9lYs%2B8OU0JlTPEEfYjHFGGYhZfOC%2Bw087wzVEib18bZ%2BiEdAHED5BLcgjdgPmRy0nEXBoxChFCmU%2FAuXC2rRfBBLMYsZCw%2FYWT1b3Hm5PJHKwXjgc4GPjuQluFebWI6yNk41rJfJ2ZxOzqltdAeqbzF1vIYSMySBqRm7I1CAJ0REsQRWksHB9M8lrZmNioEVUum6OKEHREP1WU%2BBZNlWw0tMpxqeQKzhizqLTH4Ex4ZkMFC1DqwCiNqfXQ85qmGRRSFksYZHLlWZIW5tA4XxYKoNIt3sP2TE8rFp1NnubJ1c1oPJuemOoVGCUyPfjHxEs9rb0DVGkPez8fXTyI3Gv6MPU08%2BOQ0iBiAaYI%2FRg9XF3i85XIL0lMCY0ZC4OYoijyQ0RxjJkfRiSgLAwjxCx4Pnq4ucS2odFVYkC3Z3JMSJc1vEh0Ow1OoGOc6r9B%2FSeLSli9NhxEyvPSkipo6lIaaVnT9jZP4mzJtRbZKXSvxAqeSlC8hrWxf2zxW77U7Rg9C3tkvwFelrtR3vMP2Fiua1npU4sJF8vk8XF2Ip9vn%2BQcjC10%2FLGsFkKtuBGyuudFe0WLnvpLFgXkyV3V%2FWefztbma574Ku%2Bw%2BfbUu8Nu7VCNuYKpbPrebjagdrICy6rMR8N6AM9cYRJ2qlSorEzlNkmBr80u0aWse%2BZnqebKVKB0KT5K9aaf78MATcZ3123%2Brat29v2KYp8iH9M48JFdQbN0hiwKUPvsuw8cNpZ8h91tjgvVf2T%2BV9l%2B%2Fw4%3D%22%7D; mbox=PC#8b5ec2fe469148baa00511229cb2461a.34_0#1676940877|session#6952872d3c314fdba800da15f6e008dd#1613697937; AMCV_5E16123F5245B2970A490D45%40AdobeOrg=-1124106680%7CMCIDTS%7C18677%7CMCMID%7C29727988549706635071918356247855608635%7CMCAAMLH-1614300877%7C7%7CMCAAMB-1614300877%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1613703277s%7CNONE%7CMCAID%7CNONE%7CvVersion%7C5.2.0; fc_vnum=5; XSRF-TOKEN=cMw4+wPzEbV2bA==.JpXnJ2AohDIzMiaTXsC6v+dxc7OmHF8fmLpdLBP02+4=; session_id=6191dbb7-c568-4590-8467-12985aca130b; bm_sz=133E2D4B4D1F54F6364959B934345165~YAAQNKomFzFJ3sl3AQAAB+jQzAoycgA/DA+TR2ZdvLjLEcdkkBxneNc1nay4G1smmJDwjqj7RM/jP87wM29fFx8fgWokZEtk6XafG1Y5SshIAkMUJCs57Bdf5t8D/ZerAjy+dRvQncyyreXpO2kVcS1Fh++AWRkr37naQB36L2TIr7Xgwh9GaPBJSnxpOBBTKQ2Y; rxVisitor=16140489793786AMDH87FO9DIP1AT4HGUPKG0OID870IV; dtSa=-; wag_sid=6r9yczhnp58lchhlqluduwzx; uts=1614048981803; ak_bmsc=013B843B29B694D54A422B8A5B1A30F81726AA34572C0000D26E346093320D64~plE9d97xy5jrsaeCArNlZ5QUhvg5dDqlpa/auqFS83d03+7vUJWkRhhF9T0aU9ofXUwA8Xve+7WQImpZcR6zw/CxGi26lZBn3ycRySDguaq26a4Z9foWV1b4nT54MwBX8t6asMwnjXEuTf4CgWtGo5BRmFrT4NcrjS5TQYM6EqccWp9A1ZpX4vV5sZoepYe/Y0YXOWkk70szgaBCisFgwddxt7JwlPLOHw+YZRmDRQ+KOJE9vF+LuWBRhL/2x9RgRp; rxvt=1614050783262|1614048979381; dtPC=2$48979372_79h-vGSCSRLSFAHHMWVBFETSKEGVGTWPOTUDM-0e1; gRxAlDis=N; dtCookie=2$B6ED3D59A0463324BB812500CB03EE14|0eed2717dafcc06d|1; dtLatC=1; akavpau_walgreens=1614049301~id=5e386c31b67d9f5682f8dfb43c1fac34; bm_sv=DDE9223BBAB9C09277868965E096FC39~YkMJXS7V+LGK8Fbv+6frnx9zsEuz8gUQB9EEZRxAH54r7lyxIyThNhvGsN0I6A/SkLHZi1aqIv5NZXwFnfYS4VOCR9GyqFkeG0ibRuspb5CTYQpMQ4bRHOUXkv0Wd74U5DCZ/FoPUbMYk//0tkJWby5p4yZM9BnfwnPbWJMRFu0=; _abck=297D20C2D23A8636027BC6650D1F6FAB~0~YAAQNKomF2pJ3sl3AQAA8EHRzAX+2W1eaWmBtpZg+ztk2/d2eC1JWdBD9KS1JzUaI7xL0zv5o5ew+Mz6jeX8CL26AjYu1FKmt0on9Uxm1Q9EhyKDvaBkkiNpArpR1hZ0wIJNCwyk84h9E/r4HrSo6Mt6Yfuk6DjHphB+sNxrIwNQ+bgKdfAhKKAuZ+tZ8jv3UFytO56XSZNbk8Oe8uVdeMvbrGiDfpRhbJc1X6b4ZrZgfm0X3nPukhwvWc5SEuK+BmK8JpJ9ex8rVnC757YiWR6JA9YY12UBnugSiniWmNyN4nNBO+93JrAY98KnVDO13bd6+pGlQd8Fkx7yTnbrfwJtG4JHaft60w==~-1~-1~-1'
        uri = URI.parse('https://www.walgreens.com/hcschedulersvc/svc/v1/immunizationLocations/availability')
        request = Net::HTTP::Post.new(uri)
        request.content_type = 'application/json; charset=UTF-8'
        request.body = jsonbody.to_json
        request['Authority'] = 'www.walgreens.com'
        request['Accept'] = 'application/json, text/plain, */*'
        request['Origin'] = 'https://www.walgreens.com'
        request['Sec-Fetch-Site'] = 'same-origin'
        request['Sec-Fetch-Mode'] = 'cors'
        request['Referer'] = 'https://www.walgreens.com/findcare/vaccination/covid-19/location-screening'
        request['Cookie'] = cookie
        req_options = {
          use_ssl: uri.scheme == 'https'
        }
        begin
          response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
          end
          response_data = JSON.parse(response.body)

          if response_data['appointmentsAvailable'] == true
            location.last_updated = DateTime.now
            location.when_available = DateTime.now if location.availability.blank?
            location.store_availability_count += 1 if location.availability.blank?
            location.availability = true
            puts response.body
          else
            location.availability = false
            location.last_updated = DateTime.now
          end
          location.save
        rescue StandardError => e
          location.availability = false
          location.last_updated = DateTime.now
          location.save
          puts "-- ERROR Walgreens | ID: #{location.id} | State: #{state} - Zip: #{location.zip} -- City: #{location.name} \n Message: #{e}"
          next
        end
        puts "-- SUCCESS Walgreens | Availability: #{location.availability} | ID: #{location.id} -- State: #{state} -- Zip: #{location.zip} -- City: #{location.name}"
      end
    end
  end
end


