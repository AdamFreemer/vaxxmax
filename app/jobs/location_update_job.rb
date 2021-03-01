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
        puts "-- SUCCESS Rite Aid | Index: #{i} - State: #{state} - Location ID: #{location.id} - store #: #{location.store_number} #{data}"

        if data['Data'].nil?
          puts "-- ERROR Rite Aid | Location ID: #{location.id} - store #: #{location.store_number} #{data}"
          UpdateLog.create(task: "-- ERROR Rite Aid #{location.id} - store #: #{location.store_number} #{data}")
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
            startDateTime: Date.today.strftime('%Y-%m-%d')
          }, radius: 25
        }

        cookie = 'mt.v=2.1108819582.1613442906571; s_ecid=MCMID%7C29727988549706635071918356247855608635; USER_LOC=\"sQbCfOufHNGFx6h5dD3cOuSTTri1Eu3n/l2+Qp64phEuTp5Qw1KQCbbJ33dnyUd88DrsuW+EePT1z3L2oLwqPi068zLyRwmyU8nEG735dSdxb8qzyNU85qImb5m/brR0Sk0jg2i2PJRg8N3+MwSpMRI97u1U2aTgk0JQhimXDfzEGXpahUB0ea5nFSozr9o8WhDw0yFvRYr2zxWDVV1JPOqeQZz/NZ/uPaSvRsJ6oEI=\"; _gcl_au=1.1.1329235556.1613442933; liveagent_oref=https://www.walgreens.com/login.jsp?ru=%2Ffindcare%2Fvaccination%2Fcovid-19%2Feligibility-survey%3Fflow%3Dcovidvaccine%26register%3Drx; liveagent_ptid=b2549530-febf-4f40-9dc4-792a6473eb56; encLoyaltyId=MgCBb8QiTRr8/UwemeZrfg==; 3s=xJnEt8SDxaBpxYHFgcWnccOYxIRG; FirstName=Adam; 2fa=7d5083e2916cf3428663a5291bef9790; liveagent_vc=4; _uetvid=eb324820700b11eb86a82f5c6f758fac; _gcl_aw=GCL.1613614241.CjwKCAiAmrOBBhA0EiwArn3mfHsTm5mGG9OnQZqD4gJr_NTXwSEWIQe-V4ig_VsoFlsz0L6ZTE-1eBoCBccQAvD_BwE; _gcl_dc=GCL.1613614241.CjwKCAiAmrOBBhA0EiwArn3mfHsTm5mGG9OnQZqD4gJr_NTXwSEWIQe-V4ig_VsoFlsz0L6ZTE-1eBoCBccQAvD_BwE; _4c_=%7B%22_4c_s_%22%3A%22jVNNT%2BMwEP0rKAdOpLGdDzuV0KoUkFhtWyiIPUZOMk28tHHWdpsW1P%2BO0wTa5bAil8y8ee9lYs%2B8OU0JlTPEEfYjHFGGYhZfOC%2Bw087wzVEib18bZ%2BiEdAHED5BLcgjdgPmRy0nEXBoxChFCmU%2FAuXC2rRfBBLMYsZCw%2FYWT1b3Hm5PJHKwXjgc4GPjuQluFebWI6yNk41rJfJ2ZxOzqltdAeqbzF1vIYSMySBqRm7I1CAJ0REsQRWksHB9M8lrZmNioEVUum6OKEHREP1WU%2BBZNlWw0tMpxqeQKzhizqLTH4Ex4ZkMFC1DqwCiNqfXQ85qmGRRSFksYZHLlWZIW5tA4XxYKoNIt3sP2TE8rFp1NnubJ1c1oPJuemOoVGCUyPfjHxEs9rb0DVGkPez8fXTyI3Gv6MPU08%2BOQ0iBiAaYI%2FRg9XF3i85XIL0lMCY0ZC4OYoijyQ0RxjJkfRiSgLAwjxCx4Pnq4ucS2odFVYkC3Z3JMSJc1vEh0Ow1OoGOc6r9B%2FSeLSli9NhxEyvPSkipo6lIaaVnT9jZP4mzJtRbZKXSvxAqeSlC8hrWxf2zxW77U7Rg9C3tkvwFelrtR3vMP2Fiua1npU4sJF8vk8XF2Ip9vn%2BQcjC10%2FLGsFkKtuBGyuudFe0WLnvpLFgXkyV3V%2FWefztbma574Ku%2Bw%2BfbUu8Nu7VCNuYKpbPrebjagdrICy6rMR8N6AM9cYRJ2qlSorEzlNkmBr80u0aWse%2BZnqebKVKB0KT5K9aaf78MATcZ3123%2Brat29v2KYp8iH9M48JFdQbN0hiwKUPvsuw8cNpZ8h91tjgvVf2T%2BV9l%2B%2Fw4%3D%22%7D; fc_vnum=5; AMCV_5E16123F5245B2970A490D45%40AdobeOrg=-1124106680%7CMCIDTS%7C18682%7CMCMID%7C29727988549706635071918356247855608635%7CMCAAMLH-1614658692%7C7%7CMCAAMB-1614658692%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1614061092s%7CNONE%7CMCAID%7CNONE%7CvVersion%7C5.2.0; mbox=PC#8b5ec2fe469148baa00511229cb2461a.34_0#1677298693|session#955e162af44046198b703cd8d825e71a#1614055753; XSRF-TOKEN=kYKlmmF8WnGU5Q==.M+xVAUA3BfeDO21/ZJbrCYbGxKoC9Mu9Qh9AIGjgCmE=; session_id=26f5b8c7-8e5a-46fc-be6d-c6c7b6a01c70; bm_sz=CABB6E5EB576662F0323FC8D1DFF9459~YAAQVaomF67GNcp3AQAA6R1A7ArwBEfYZNwG+fBjtSiunL2H6OnAzaJl1QYVy3SU94t8P4JTeWL+RMpJFlTs8aOb78l1hJDwKod+vygayMbwFSmR1mMJ9vPvHyl5RSYkgGNLR+ApRvZHzR1V4rGl9i6HqMd8++/AZ0b0ljuDvPf/EJJOxkM5bOvpIh1KWsS8bkfU; rxVisitor=1614576361042IT8MNQ79N6E0IKPPV1KJQ5FEU2PKR17I; dtSa=-; wag_sid=esd7xcwdbtlk5t0cqmmcxmr1; uts=1614576361757; ak_bmsc=AAAEE66E876399ECF9442AD7E3117ADD1726AA5570290000E97A3C60470E0614~plpiJuN6RGz09OVhOl5lKA360nmLwqmbGBxuCPlBPCBd7GDT06+eCoMK225mEXQSXiNce1zZQrIEk3xUHpI9wh+qbFyJQdOf48WzXu4xlUWJ53puCUWuXRDPLcPgHpqjP8w/vZHTrWwjJ9edjo4XvvXzjrdrO2kQZ9WoHgKWrp8fnXWoN76wj6NSldeBkIk9v8xjSAJpybKJ6Ww3UofGSexd2N7ogTcYVn90KKjowwtdVQ3LPZMpqj6o3GwXojZEsF; gRxAlDis=N; dtCookie=3$504E938E47B63940F1AF41C7F6515F3E|0eed2717dafcc06d|1; _abck=297D20C2D23A8636027BC6650D1F6FAB~0~YAAQVaomFy7INcp3AQAAkBBB7AUPhgekEOAjaXH8w8fI/RmLLBHcx34aBFOoUlNjfSomyBn4IDNs02u4uVEBlfR72l1LPvKYTBsY02HIVjC6NoEeBTUrYvsUGMHp6+rC+Cfnk+i2+GHqHx2qOP1S7PnfhCG6CGF1bTFIfStNMA23i3IK0vbrwYtejdrrPTuA1y73RaSqAyrJYL/ZuA85hyVrirGO5/5P6QGQUlN8Kc47uFNDanbq4xCCLTgUDnCj9oNcGiyHPla/cEtaguZug6uzgKleyPjfFfCxpptBatnn/mnaAsM33U11HNPcDc07c6yEQH/adTc4/V4q+cCNKjYTS+ahnlYwbn+jFGEOGAa6Vpz7bCHlGkRWfRD7/iNER36qwg7+jSZdvUnr55SBrwfN+135jbZ/HNz2~-1~-1~-1; dtLatC=3; rxvt=1614578225797|1614576361045; dtPC=3$576423145_40h-vRFPETECUKMJETCRAUCIPMUUOACFHEWBA-0e4; akavpau_walgreens=1614576729~id=a09e78360b91830573e4433ac10ca471; bm_sv=D70C40613E4ABCF777BF25140457C564~pCLgaYG8fRgna/qb2GF8j0kVa69sujqHRu9kR3M0gIVtZ5UQUns1ALQcv5OhyWRh/GzYaO45xU6Zve9ajYmyok0Y2jSdGoz3Vjh1joi9f1Q0AjU7KXVfuqgZ1QlWxYTge6KdJgNkai0o1+XVw5hXHccDt8yzLSXg6wNS9r0vGgg='
        uri = URI.parse('https://www.walgreens.com/hcschedulersvc/svc/v1/immunizationLocations/availability')
        request = Net::HTTP::Post.new(uri)
        request.content_type = 'application/json; charset=UTF-8'
        request.body = jsonbody.to_json
        request['Authority'] = 'www.walgreens.com'
        request['Accept'] = 'application/json, text/plain, */*'
        request['X-Xsrf-Token'] = 'oXpoIRk90BDGLA==.BXniRPVyEh/M51ry+maU5iPeeCGsfSbe7U7jxKkuxC4='
        request['Origin'] = 'https://www.walgreens.com'
        request['Sec-Ch-Ua-Mobile'] = '?0'
        request['Sec-Fetch-Site'] = 'same-origin'
        request['Sec-Fetch-Mode'] = 'cors'
        request['Sec-Fetch-Dest'] = 'empty'
        request['Referer'] = 'https://www.walgreens.com/findcare/vaccination/covid-19/location-screening'
        request['Accept-Language'] = 'en-US,en;q=0.9,ca;q=0.8'
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
            # location.store_availability_count += 1 if location.availability.blank?
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
