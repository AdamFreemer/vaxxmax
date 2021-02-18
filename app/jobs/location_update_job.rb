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

    def rite_aid_update(state)
      @locations = Location.where(state: state, store_name: 'Rite Aid')
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
          puts "-- ERROR : Location ID: #{location.id} - store #: #{location.store_number} #{data}"
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

    def walgreens
      
      uri = URI.parse("https://www.walgreens.com/hcschedulersvc/svc/v1/immunizationLocations/availability")
      request = Net::HTTP::Get.new(uri)
      request.content_type = "application/json; charset=UTF-8"
      request["Authority"] = "www.walgreens.com"
      request["Accept"] = "application/json, text/plain, */*"
      request["Origin"] = "https://www.walgreens.com"
      request["Sec-Fetch-Site"] = "same-origin"
      request["Sec-Fetch-Mode"] = "cors"
      request["Referer"] = "https://www.walgreens.com/findcare/vaccination/covid-19/location-screening"
      request["Cookie"] = "XSRF-TOKEN=JDXrtqRQAnL1JQ==.GEnQWFrLLwVeK4+0fJaLcC9c6zWOQqPaTcMoxauSe6Y=; rxVisitor=1613442904614RB8IHAF78T8CLFD9UFENGM4EETCRAFED; uts=1613442906555; mt.v=2.1108819582.1613442906571; AMCVS_5E16123F5245B2970A490D45%40AdobeOrg=1; s_ecid=MCMID%7C29727988549706635071918356247855608635; Adaptive=true; USER_LOC=\"sQbCfOufHNGFx6h5dD3cOuSTTri1Eu3n/l2+Qp64phEuTp5Qw1KQCbbJ33dnyUd88DrsuW+EePT1z3L2oLwqPi068zLyRwmyU8nEG735dSdxb8qzyNU85qImb5m/brR0Sk0jg2i2PJRg8N3+MwSpMRI97u1U2aTgk0JQhimXDfzEGXpahUB0ea5nFSozr9o8WhDw0yFvRYr2zxWDVV1JPOqeQZz/NZ/uPaSvRsJ6oEI=\"; at_check=true; s_cc=true; nsl=1; p_s=1; dtCookie=2$FFB9002CE40E2802B96AFDA54DEAEFE7|0eed2717dafcc06d|1; _gcl_au=1.1.1329235556.1613442933; gRxAlDis=N; IM_throttle_1223=on; liveagent_oref=https://www.walgreens.com/login.jsp?ru=%2Ffindcare%2Fvaccination%2Fcovid-19%2Feligibility-survey%3Fflow%3Dcovidvaccine%26register%3Drx; liveagent_ptid=b2549530-febf-4f40-9dc4-792a6473eb56; encLoyaltyId=MgCBb8QiTRr8/UwemeZrfg==; 3s=xJnEt8SDxaBpxYHFgcWnccOYxIRG; FirstName=Adam; 2fa=7d5083e2916cf3428663a5291bef9790; liveagent_sid=6ee0ea3b-ecbe-437c-902f-426e92f4af12; liveagent_vc=4; _uetvid=eb324820700b11eb86a82f5c6f758fac; IM_shown_1223=true; headerReset=true; session_id=041ea9cc-fee3-4a23-b855-6d795b73d559; bm_sz=455FCF13298B69FDB3EA7C7F251587B3~YAAQFYPCF08kM0B3AQAA5KLmsgrACxJnpnVwurd/32On2xFLP64zCMZUPSXl9wpLTtsoGNELVnmakNGypdjvWJWyesXCecy2V58aEzdQyqBgf5y8eO64kvZdmBOHUVb71Y1Um4esB0klhLcetSuJcA6P8cUA5vdha+5OSIt7ddhClxBHMN9RqlEENhsFEBkghFT6; bm_mi=DB99CB8F9E4DAEFF3719028B7D6BC536~1gsXOhx/egRe+S/4W1wrUyF2FzUhuljwW+iKEGCzUJcsdGXgr4+L/Hbpt8eGkM2ZdhOVf9odJetyEziljDBWc1LmrRo6UapIRlJRqTJzhdAPN61ncUYKVXQpgWA1gIGvGXrodhkFK1a76e7oqCFe28BhYmkF/D98BDK5Gz+erorF7ufT4OKEwvDs5yKiV3HoonuhuMONynfrssvxTXm+cSzUPSy1qM3D/cFtVp0N5Y6IVlo33I/Ww9jo0jkbnhlzdcCwq1bgy2FdUf+wA8fSGzzw7D9rzJCbdD4w18TVF/dZD6HePTXhSMaZJip4T8VD; wag_sid=4s91bsq4pjc6hemzwaeibadh; ak_bmsc=5B35E2F5D00904E037D0FDB0300707C217C28315A342000073CC2D60924AFE76~plyU/5RmwvbfviJWZKoO4KLHpxfojrTWHT3PTDxV6N3vcXzsTCgu5NUZQipM6iQNumc494j7F564fvmgrixceyvYpHrgoVTxKQzwmwkv8dMST83Xs3OHA9EAV+iNYtzV6QpCZmCVsawoEFpCFN5Wt9blmkopbL+/1jdb+Y6Yk/lMzHenStpo4m8x47vvaC5PJHeU2xvu2iqur4Tg7JMyBhwc6Hh2OUslfUVBk8wonMdZjIMgsHV7447gX1Rg0jrWQc; _gcl_aw=GCL.1613614241.CjwKCAiAmrOBBhA0EiwArn3mfHsTm5mGG9OnQZqD4gJr_NTXwSEWIQe-V4ig_VsoFlsz0L6ZTE-1eBoCBccQAvD_BwE; _gcl_dc=GCL.1613614241.CjwKCAiAmrOBBhA0EiwArn3mfHsTm5mGG9OnQZqD4gJr_NTXwSEWIQe-V4ig_VsoFlsz0L6ZTE-1eBoCBccQAvD_BwE; mt.sc=%7B%22i%22%3A1613616737260%2C%22d%22%3A%5B%5D%7D; JSESSIONID=hk9YSLACd6T1i6QivkODpFUm.p_dotcom85; wag_sc_ss_id=-6696416735484281296; mboxEdgeCluster=34; mt.mbsh=%7B%22fs%22%3A1613616738274%2C%22s%22%3A%5B%22NS_CA_ST-199_DCH_Providence_20180517%2CA100_Experiment%22%2C%22AM_CA_1471247_HearingTier2Banner_20201206_100%2C%20Experiment%22%5D%2C%22sf%22%3A1%2C%22lf%22%3A1613616738287%7D; _4c_=%7B%22_4c_s_%22%3A%22jVNNT%2BMwEP0rKAdOpLGdDzuV0KoUkFhtWyiIPUZOMk28tHHWdpsW1P%2BO0wTa5bAil8y8ee9lYs%2B8OU0JlTPEEfYjHFGGYhZfOC%2Bw087wzVEib18bZ%2BiEdAHED5BLcgjdgPmRy0nEXBoxChFCmU%2FAuXC2rRfBBLMYsZCw%2FYWT1b3Hm5PJHKwXjgc4GPjuQluFebWI6yNk41rJfJ2ZxOzqltdAeqbzF1vIYSMySBqRm7I1CAJ0REsQRWksHB9M8lrZmNioEVUum6OKEHREP1WU%2BBZNlWw0tMpxqeQKzhizqLTH4Ex4ZkMFC1DqwCiNqfXQ85qmGRRSFksYZHLlWZIW5tA4XxYKoNIt3sP2TE8rFp1NnubJ1c1oPJuemOoVGCUyPfjHxEs9rb0DVGkPez8fXTyI3Gv6MPU08%2BOQ0iBiAaYI%2FRg9XF3i85XIL0lMCY0ZC4OYoijyQ0RxjJkfRiSgLAwjxCx4Pnq4ucS2odFVYkC3Z3JMSJc1vEh0Ow1OoGOc6r9B%2FSeLSli9NhxEyvPSkipo6lIaaVnT9jZP4mzJtRbZKXSvxAqeSlC8hrWxf2zxW77U7Rg9C3tkvwFelrtR3vMP2Fiua1npU4sJF8vk8XF2Ip9vn%2BQcjC10%2FLGsFkKtuBGyuudFe0WLnvpLFgXkyV3V%2FWefztbma574Ku%2Bw%2BfbUu8Nu7VCNuYKpbPrebjagdrICy6rMR8N6AM9cYRJ2qlSorEzlNkmBr80u0aWse%2BZnqebKVKB0KT5K9aaf78MATcZ3123%2Brat29v2KYp8iH9M48JFdQbN0hiwKUPvsuw8cNpZ8h91tjgvVf2T%2BV9l%2B%2Fw4%3D%22%7D; AMCV_5E16123F5245B2970A490D45%40AdobeOrg=-1124106680%7CMCIDTS%7C18677%7CMCMID%7C29727988549706635071918356247855608635%7CMCAAMLH-1614221588%7C7%7CMCAAMB-1614221588%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1613623988s%7CNONE%7CMCAID%7CNONE%7CvVersion%7C5.2.0; mbox=PC#8b5ec2fe469148baa00511229cb2461a.34_0#1676861590|session#2bd050b2070d42d7bc35f440ffe99134#1613618598; fc_vnum=4; fc_vexp=true; s_sq=walgrns%3D%2526c.%2526a.%2526activitymap.%2526page%253Dwg%25253Afindcare%25253Acovid19%252520vaccination%25253Aland%2526link%253DGet%252520started%2526region%253DuserOptionButtons%2526pageIDType%253D1%2526.activitymap%2526.a%2526.c%2526pid%253Dwg%25253Afindcare%25253Acovid19%252520vaccination%25253Aland%2526pidt%253D1%2526oid%253Dhttps%25253A%25252F%25252Fwww.walgreens.com%25252Ffindcare%25252Fvaccination%25252Fcovid-19%25252Flocation-screening%2526ot%253DA; _abck=297D20C2D23A8636027BC6650D1F6FAB~0~YAAQroPCF3HvcT93AQAACHAOswWgP3Tm6zSXrBYAerzLEiGCotCICnl2Bw/k9Z+NoGU+uBskC7MGCt7oFrMKSBhxYvXIA0XzaT1DfzqYM7xdH2YiLTv46iazGw5jDa1Ht7bzQA3MGPnNjLRR2kMBwK16K4fYOc+3Bx7U79f6A2+10CJBr2YSvqowf5ZZShjrP/a+yiMN2swBTfMPyshNq81NMwh2J2U2rlIvBZWQ08XbqiDZSOXN9FdCzn62Qle/YGZFUREp3F2ydsA5b+PeCKMPOodD2fBRp1rg05W+vyYi9N8FtgierADf53MHwlQCg6BIGhVyTcidDOTjPITzLfyaggY/nRbnzw==~-1~-1~-1; dtSa=-; rxvt=1613618606385|1613616406493; dtPC=2$216803923_644h-vMDPIKPBOHLIARBFLMCWOALOMQKAMECDB-0e7; akavpau_walgreens=1613617111~id=36f092520ab26af894bfe997ee22c7b1; dtLatC=1; bm_sv=1818BFD8F8F7FAEA08645EE6F017CDAC~Wy73IZmKJ//S/jawSlGOMN1LbfcX4iznwhLFHgWorZD14nK9COGaF0t5p1Oe884EmA42sXjkDgf33L7jWFWj7RLeEW7F0fwTsufw4W4t2hLTYN2hY2h8+JnmMieojPnWrnMi4zG+SY7mMoDAPk9rdoCGUH00zZASqeOVi9A2H5U="
      
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      
      response.code
      response.body
      
    
    end
  end
end
