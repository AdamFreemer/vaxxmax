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
      # UpdateLog.create(task: 'update_locations_north_east')
    end

    def update_locations_mid_atlantic
      rite_aid_update('PA')
      rite_aid_update('DE')
      rite_aid_update('MD')
      # UpdateLog.create(task: 'update_locations_mid_atlantic')
    end

    def update_locations_west
      rite_aid_update('CA')
      rite_aid_update('NV')
      # UpdateLog.create(task: 'update_locations_west')
    end

    def update_locations_north_west
      rite_aid_update('WA')
      rite_aid_update('ID')
      rite_aid_update('OR')
      # UpdateLog.create(task: 'update_locations_north_west')
    end

    def update_locations_midwest
      rite_aid_update('OH')
      rite_aid_update('MI')
      rite_aid_update('VA')
      # UpdateLog.create(task: 'update_locations_midwest')
    end

    def update_pa
      rite_aid_update('PA')
      # UpdateLog.create(task: 'update_locations_midwest')
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

    def update_cvs
      states.each do |state|
        cvs_update(state)
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
          puts "-- ERROR Rite Aid | #{state} | #{location.city} | #{location.store_number}"
          data = nil
          # UpdateLog.create(task: "-- ERROR #{location.id} - store #: #{location.store_number} #{data}")
          next
        end
        puts "-- SUCCESS Rite Aid | #{data['Data']['slots']['1']} | #{state} | id: #{location.id} | store: #{location.store_number}"

        if data['Data'].nil?
          puts "-- ERROR Rite Aid | ID: #{location.id} | Store: #{location.store_number}"
          # UpdateLog.create(task: "-- ERROR Rite Aid #{location.id} - store #: #{location.store_number} #{data}")
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

    def walgreens_update(state) 
      puts "-- Starting Walgreens update for state: #{state} --------"

      locations = WalgreensCity.where(state: state)
      locations.each do |location|
        sleep 2 
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

        proxy_addr = ENV["PROXIMO_URL"] if ENV["PROXIMO_URL"]
        uri = URI.parse("https://www.walgreens.com/hcschedulersvc/svc/v1/immunizationLocations/availability")
        request = Net::HTTP::Post.new(uri, proxy_addr)
        request.content_type = 'application/json; charset=UTF-8'
        request.body = jsonbody.to_json
        request["Authority"] = 'www.walgreens.com'
        request["Sec-Ch-Ua"] = '\"Google Chrome\";v=\"89\", \"Chromium\";v=\"89\", \";Not A Brand\";v=\"99\"'
        request["Accept"] = "application/json, text/plain, */*"
        request["X-Xsrf-Token"] = "fU3Jr3jGh/EzSw==.UJu/rqQs0y9mFjgRsU+cQsubz3FiV65leJ83jHCCohQ="
        request["Sec-Ch-Ua-Mobile"] = "?0"
        request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36"
        request["Origin"] = "https://www.walgreens.com"
        request["Sec-Fetch-Site"] = "same-origin"
        request["Sec-Fetch-Mode"] = "cors"
        request["Sec-Fetch-Dest"] = "empty"
        request["Referer"] = "https://www.walgreens.com/findcare/vaccination/covid-19/location-screening"
        request["Accept-Language"] = "en-US,en;q=0.9,ca;q=0.8"
        request["Cookie"] = 'mt.v=2.1108819582.1613442906571; s_ecid=MCMID%7C29727988549706635071918356247855608635; _gcl_au=1.1.1329235556.1613442933; liveagent_oref=https://www.walgreens.com/login.jsp?ru=%2Ffindcare%2Fvaccination%2Fcovid-19%2Feligibility-survey%3Fflow%3Dcovidvaccine%26register%3Drx; liveagent_ptid=b2549530-febf-4f40-9dc4-792a6473eb56; encLoyaltyId=MgCBb8QiTRr8/UwemeZrfg==; 3s=xJnEt8SDxaBpxYHFgcWnccOYxIRG; FirstName=Adam; 2fa=7d5083e2916cf3428663a5291bef9790; liveagent_vc=4; _gcl_aw=GCL.1613614241.CjwKCAiAmrOBBhA0EiwArn3mfHsTm5mGG9OnQZqD4gJr_NTXwSEWIQe-V4ig_VsoFlsz0L6ZTE-1eBoCBccQAvD_BwE; _gcl_dc=GCL.1613614241.CjwKCAiAmrOBBhA0EiwArn3mfHsTm5mGG9OnQZqD4gJr_NTXwSEWIQe-V4ig_VsoFlsz0L6ZTE-1eBoCBccQAvD_BwE; _4c_=%7B%22_4c_s_%22%3A%22jVNNT%2BMwEP0rKAdOpLGdDzuV0KoUkFhtWyiIPUZOMk28tHHWdpsW1P%2BO0wTa5bAil8y8ee9lYs%2B8OU0JlTPEEfYjHFGGYhZfOC%2Bw087wzVEib18bZ%2BiEdAHED5BLcgjdgPmRy0nEXBoxChFCmU%2FAuXC2rRfBBLMYsZCw%2FYWT1b3Hm5PJHKwXjgc4GPjuQluFebWI6yNk41rJfJ2ZxOzqltdAeqbzF1vIYSMySBqRm7I1CAJ0REsQRWksHB9M8lrZmNioEVUum6OKEHREP1WU%2BBZNlWw0tMpxqeQKzhizqLTH4Ex4ZkMFC1DqwCiNqfXQ85qmGRRSFksYZHLlWZIW5tA4XxYKoNIt3sP2TE8rFp1NnubJ1c1oPJuemOoVGCUyPfjHxEs9rb0DVGkPez8fXTyI3Gv6MPU08%2BOQ0iBiAaYI%2FRg9XF3i85XIL0lMCY0ZC4OYoijyQ0RxjJkfRiSgLAwjxCx4Pnq4ucS2odFVYkC3Z3JMSJc1vEh0Ow1OoGOc6r9B%2FSeLSli9NhxEyvPSkipo6lIaaVnT9jZP4mzJtRbZKXSvxAqeSlC8hrWxf2zxW77U7Rg9C3tkvwFelrtR3vMP2Fiua1npU4sJF8vk8XF2Ip9vn%2BQcjC10%2FLGsFkKtuBGyuudFe0WLnvpLFgXkyV3V%2FWefztbma574Ku%2Bw%2BfbUu8Nu7VCNuYKpbPrebjagdrICy6rMR8N6AM9cYRJ2qlSorEzlNkmBr80u0aWse%2BZnqebKVKB0KT5K9aaf78MATcZ3123%2Brat29v2KYp8iH9M48JFdQbN0hiwKUPvsuw8cNpZ8h91tjgvVf2T%2BV9l%2B%2Fw4%3D%22%7D; mbox=PC#8b5ec2fe469148baa00511229cb2461a.34_0#1677298693|session#955e162af44046198b703cd8d825e71a#1614055753; bm_sz=31CB2E4A184B0C045F69D67091F10146~YAAQTu0BF4SbtlR4AQAARHQvWAsytLuCgbYr2raUaMkGJOkSbdnF8FEQr3M/qTNII3TnnzowkSELtd27E3L56AEXo1xM4WCqvLr6dSYTAL/DaWkVgwuXxiMoJV/mibIq9/0ybBLOdclCNQYa5ibwa5T9g79omsww4jnJ2WjGGkEKIa/zMdb5KgfA4UdKSKi3o38=; rxVisitor=16163872086756T6ELCL5QHM93MQ8748V8SH581SC666T; wag_sid=ogso15w29g7gshyefkhtir6m; uts=1616387209360; ak_bmsc=368CC90CD33F60061F6FC20105A48D521701ED4E15580000881C586054C9CF0C~plbr9JSCYUBUlUeHpxbdJcuIHOMA5f2pCok1bClKyfeJLzbtGm6gGoq+XNayowBkKw0Jhbiecam+r9LW3FoJnWc8lVzNECaNgelZDzcmha6C1gXlAugS4Fd6OLxqvCNxlo+0DLaY1xEH12KeGuOF1xpGX6xfJAVyiCmNgheq4Bd0Fgt/mMyfdgsT5i/vQ1qbaPfL2MNuUAZhDEshxUPZzjKXzwRoQT11WmM6LbT1f8Sz+MS+9ErEhkfCGG2khouFcx; fc_vnum=7; fc_vexp=true; AMCVS_5E16123F5245B2970A490D45%40AdobeOrg=1; AMCV_5E16123F5245B2970A490D45%40AdobeOrg=-1124106680%7CMCIDTS%7C18709%7CMCMID%7C29727988549706635071918356247855608635%7CMCAAMLH-1616992011%7C9%7CMCAAMB-1616992011%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1616394411s%7CNONE%7CMCAID%7CNONE%7CvVersion%7C5.2.0; gpv_Page=https%3A%2F%2Fwww.walgreens.com%2Ffindcare%2Fvaccination%2Fcovid-19%3Fban%3Dcovid_vaccine_landing_schedule; s_cc=true; s_sq=walgrns%3D%2526c.%2526a.%2526activitymap.%2526page%253Dwg%25253Afindcare%25253Acovid19%252520vaccination%25253Aland%2526link%253DSchedule%252520new%252520appointment%2526region%253DuserOptionButtons%2526pageIDType%253D1%2526.activitymap%2526.a%2526.c%2526pid%253Dwg%25253Afindcare%25253Acovid19%252520vaccination%25253Aland%2526pidt%253D1%2526oid%253Dhttps%25253A%25252F%25252Fwww.walgreens.com%25252Ffindcare%25252Fvaccination%25252Fcovid-19%25252Flocation-screening%2526ot%253DA; XSRF-TOKEN=igB3rFX5gJblPg==.s+YZwUraPMeT54k644K97IXGLNNQxSqcxuOThRbsUBw=; session_id=05971da7-a486-4444-849e-f751c188c4d2; dtCookie=6$F381SAL9J63725H3NHVEKGCHHUEFNOBP|0eed2717dafcc06d|1; _abck=297D20C2D23A8636027BC6650D1F6FAB~0~YAAQTu0BF4abtlR4AQAAgogvWAVdEc0fEjDZtS2OKpIJ+XDyK6t1ROUqn4UfoVnsIa9o5uFyTiXHfytEH74Kk+2P0ivT7wfyWj2vMJ2IG6FWEx8HKY2v10isMEkEhtzmIYs3llbbiOeOJUT1/nDMYhYAq/BMsfc5z46fH8axVu/DpT1n9iwinFtzxqDzp4zAJW9gLCYFbjLFKlRa1YtJ1xUp3OLXQaCd+mBT76qJJxOTFMEZC5Bl243TTEigO4p9qGSbynOhZdv27HgZAIrAV1GsLqXV9i+Z3NzjNs5jH1EM+xvY9zIkhQ69MP3SRR0XR1D6HO38T/Gsa4t1PGLH1AmCW6kInIJ/uXSYEZjHe8xM8zJ7oUFxS+wdwFWRALpb/GI03xKjzmuxu9H/wVAXZvD1bM1IfL2FL2Op~-1~-1~-1; dtSa=-; USER_LOC=2%2BsKJSc9HtK8VDOlI6Wy1DufCKUgUi6AKufVbqZD%2BCZBfBetdGRYxkr1iA87JKZb; rxvt=1616389015176|1616387208677; dtPC=6$587213534_539h-vWRHHQIBJAESOLMKSSUBIMPUUCAHMMVFS-0e2; gRxAlDis=N; bm_sv=C23DF5FD7FB4DDEEAB206636468472FA~aLLrmy9cRreb70ajp/VBjOKg5inNNJ4G5j8ADBuR1t+cyz+KK4s3yjT4fZY7oO5OhMspHxHcDFOHlZM3vLH05zuFDHB0GPVQZ/wpSMiFce6lZRWDkVa6vLwuw6dAURHooSrhFaAZTXLD28qJvlbQFozeOP16aFpKFs6r7tqPOX0=; akavpau_walgreens=1616387519~id=484cbe15007f05787a2e4d69214bdf82; dtLatC=1'
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
          puts "-- ERROR Walgreens | #{location.id} | #{state} | #{location.name} \n Message: #{e}"
          next
        end
        puts "-- SUCCESS Walgreens | #{location.availability} | #{state} | #{location.name} | #{location.id}"
      end
    end

    def cvs_update(state)
      uri = URI.parse("https://www.cvs.com/immunizations/covid-19-vaccine.vaccine-status.#{state}.json?vaccineinfo")
      request = Net::HTTP::Get.new(uri)
      request['Authority'] = 'www.cvs.com'
      request['Sec-Ch-Ua'] = '\"Google Chrome\";v=\"89\", \"Chromium\";v=\"89\", \";Not A Brand\";v=\"99\"'
      request['Sec-Ch-Ua-Mobile'] = '?0'
      request['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36'
      request['Accept'] = "*/*"
      request['Sec-Fetch-Site'] = 'same-origin'
      request['Sec-Fetch-Mode'] = 'cors'
      request['Sec-Fetch-Dest'] = 'empty'
      request['Referer'] = 'https://www.cvs.com/immunizations/covid-19-vaccine'
      request['Accept-Language'] = 'en-US,en;q=0.9,ca;q=0.8'
      request['Cookie'] = 'QuantumMetricSessionLink=https://cvs.quantummetric.com/#/users/search?autoreplay=true&qmsessioncookie=3da1af1685a03680c444ab89c0bfb0c7&ts=1615210792-1615297192; aat1=off-p1; adh_ps_pickup=on; bbcart=on; sab_newfse=on; sab_displayads=on; flipp2=on; mc_rio_locator3=on; mc_ui_ssr=off-p2; mc_videovisit=on; pivotal_forgot_password=off-p0; pivotal_sso=off-p0; ps=on; rxhp=on; rxhp-two-step=off-p0; rxm=on; sab_deals=on; s2c_akamaidigitizecoupon=on; s2c_digitizecoupon=on; s2c_herotimer=off-p0; s2c_prodshelf=on; s2c_persistEcCookie=on; s2c_smsenrollment=on; sftg=on; show_exception_status=on; mt.v=2.962368776.1613442773357; _group1=quantum; gbi_visitorId=ckl7e642f00013h8ap6dah2is; _gcl_au=1.1.1715659146.1613442774; _4c_mc_=3ca99ea1-be0f-45c6-bbe8-f206e6ac0c03; QuantumMetricUserID=5f1b64dff5ec1a96970e18651bfc0eec; DG_IID=21062F8D-74FF-3494-B8BE-19A141EC17CB; DG_UID=56C92743-ED20-34A3-9317-DEA9B87B0D77; DG_ZID=F796FC51-7489-3CFF-94D1-53309BB2246A; DG_ZUID=B077AA0C-6174-33B3-A6A9-14529828128C; DG_HID=D8469F65-C8B5-3C1E-89ED-AF8232F224AD; DG_SID=69.242.71.104:SJUR3uJGcIJnJsJp95yssDiofp2j+Mv8ICwDHss5W08; CVPF=3YelhELO9F24ovsR6GnNMZIIraxuCzyqx9mYC6gpXUIXL86ykQK08iQ; pe=p1; acctdel_v1=on; adh_new_ps=on; adh_ps_refill=on; buynow=off; dashboard_v1=off; db-show-allrx=on; disable-app-dynamics=on; disable-sac=on; dpp_cdc=off; dpp_drug_dir=off; dpp_sft=off; getcust_elastic=on; echomeln6=off-p0; enable_imz=on; enable_imz_cvd=on; enable_imz_reschedule_instore=off; enable_imz_reschedule_clinic=off; gbi_cvs_coupons=true; ice-phr-offer=off; v3redirecton=false; mc_cloud_service=on; mc_hl7=on; mc_home_new=off1; memberlite=on; pbmplaceorder=off; pbmrxhistory=on; refill_chkbox_remove=off-p0; rxdanshownba=off; rxdfixie=on; rxd_bnr=on; rxd_dot_bnr=on; rxdpromo=on; rxduan=on; rxlite=on; rxlitelob=off; rxm_phone_dob=off-p1; rxm_demo_hide_LN=off; rxm_phdob_hide_LN=on; rxm_rx_challenge=on; s2c_beautyclub=off-p0; s2c_dmenrollment=off-p0; s2c_newcard=off-p0; s2c_papercoupon=on; s2cHero_lean6=on; sft_mfr_new=on; v2-dash-redirection=on; ak_bmsc=D9426B81C29619EDAC979244602DDFB7173BFB1443230000E5D14660947CFE6E~plFD+u70plJDCG1N5DHsjuDiwCHqSUGSGm7E59itHskcL/vlux65uWyZ22BHrMUgiT6FoSB3lQbs+3nagffbDY/aBlNjs2jnWPQ5JKXFU2pl8jTQqoOYvIudJRVBiGWjAI19vLgZA0kSiU5KSnothRh2jxeAbbZyfxjBOvFWDKzmmNE7WVQF2L6BiMaRoJRkdotLnwztW5LCCdQh9j3RLDv7kohojPGrE5XSq7YVK41cc=; bm_sz=9A3AB60D0139E380D9F3E45E3C69A5D1~YAAQFPs7F7vmLMt3AQAAr+mjFAvCrOgMQd1xeBsfmdmzlR1nTQs1hs/srBbtykwMMaRMzTiQMHkOwzu0HX+1r2RdfZVoY/XlQS0qmAK+trsq1sBlukDpF4cOlpDwqSRXXEL4MUsc7rO5wvXUqhG5+qj1ECXjIDFYkWZ5dpByJBLfyeRhlIYNEHKGSYUX; AMCVS_06660D1556E030D17F000101%40AdobeOrg=1; AMCV_06660D1556E030D17F000101%40AdobeOrg=-330454231%7CMCIDTS%7C18696%7CMCMID%7C24975331609407932531258715638357114061%7CMCAAMLH-1615858790%7C7%7CMCAAMB-1615858790%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1615261190s%7CNONE%7CMCAID%7CNONE%7CvVersion%7C3.1.2; mt.sc=%7B%22i%22%3A1615253990283%2C%22d%22%3A%5B%5D%7D; gpv_p10=www.cvs.com%2Fimmunizations%2Fcovid-19-vaccine; s_cc=true; QuantumMetricSessionID=3da1af1685a03680c444ab89c0bfb0c7; gbi_sessionId=ckm1ciszp00003g997lgh4r27; _abck=10EA17C5C15B81B173E49A2491E8CBC2~0~YAAQFPs7FynnLMt3AQAAKvSjFAU2GIciQJtHNz8072KwBa4m5XQ9sTPMnCYYNoBNgOkVbcH0mkuIQta5jWEQuSM9NNnLEjlVlNo8pUtC4C4s6Zi09tslDgn6TV0Yz4PLIaiCNzPrnK2TCLHay1uwiWXdKC5zKvcARJcKWetA9DBpWbpDP4UUcEurXYtk/4lefwttBNIirQ6vj+HYzXpxQcsKkj7L2PfbVDFQdFoNv0rspai7LBurINmrfVmFOU8jkBvYfO2vw4MGJly28M6b6TEST8U/zENj/fD/vuPpqkBEHF/yobbcIyZ3BnF/HY5tTGH+Qx8uAgbiLRwKIHuhfOBgMUo4kElX5C2ZKXK2BxNGDktox6QMUZMAgFqCq51cx9A7KE86/DpIurxPDnqGaNPoAxH6~-1~||-1||~-1; akavpau_www_cvs_com_general=1615254463~id=5847f924cb305296c71c25852de531b5; ADRUM_BT=R:50|g:a13a6f9b-0b30-4450-bc6b-d642163394d34118253|i:81658|e:6|n:customer1_28053a73-9130-49bc-bebe-00daf9afaf35; bm_sv=606DD5F1A74BA7DA26678B0E8CE0D352~JmNl+MerxFUFGeioXiqu+RKao1OpYtIfUbocUWViUQQyrik0hdLuTLcieS5FwZdQg6+g2zZmG7aJFv/3irRdtWuIkDw4Cu55ur/xBMcL0xcukGP/RgblzzE/mou+YJm7dMPGW7rqT14g2Sctq43zIA==; RT=\"z=1&dm=cvs.com&si=69b43103-3bf2-43fa-9e89-390984627140&ss=km1ciqxw&sl=3&tt=6x9&bcn=%2F%2F17d09917.akstat.io%2F&ld=184o&nu=1ssnj1p3&cl=1qaf\"; qmexp=1615255870332; gpv_e5=cvs%7Cdweb%7Cimmunizations%7Ccovid-19-vaccine%7Cpromo%3A%20covid-19%20vaccines%20in%20pennsylvania%20modal; s_sq=%5B%5BB%5D%5D; utag_main=v_id:0177a8aef1ba000aca39313d17350307900140710093c$_sn:3$_ss:0$_st:1615255870521$vapi_domain:cvs.com$_pn:2%3Bexp-session$ses_id:1615253989944%3Bexp-session'
      req_options = {
        use_ssl: uri.scheme == 'https'
      }
      begin
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        data = JSON.parse(response.body)
        if data['responsePayloadData']['data'].empty?
          # return
        else
          payload = data['responsePayloadData']['data'][state]
          cvs_parse(payload, state)
        end
      rescue StandardError => e
        puts "-- ERROR CVS | #{state} | \n Message: #{e}"
      end
    end

    def cvs_parse(payload, state)
      return if payload.blank? || state.blank?

      data = payload[state]
      data.each do |site_location|
        location = CvsCity.find_by(state: state, name: site_location['city']&.titleize)
        next if location.blank?

        if site_location['status'] == "Available"
          location.last_updated = DateTime.now
          location.when_available = DateTime.now if location.availability.blank?
          location.availability = true
        else
          location.availability = false
          location.last_updated = DateTime.now
        end
        location.save
        puts "-- SUCCESS CVS | #{location.availability} | #{state} | #{location.name} | #{location.id}"
      end
    end

    def states
      [ 'AL', 'AK', 'AS', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC',
        'FM', 'FL', 'GA', 'GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS',
        'KY', 'LA', 'ME', 'MH', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO',
        'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'MP',
        'OH', 'OK', 'OR', 'PW', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN',
        'TX', 'UT', 'VT', 'VI', 'VA', 'WA', 'WV', 'WI', 'WY'
      ]
    end
  end
end
