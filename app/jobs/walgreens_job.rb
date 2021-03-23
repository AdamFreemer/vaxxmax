class WalgreensJob
  require 'open-uri'

  class << self
    def parse_walgreens
      mechanize = Mechanize.new
      page = mechanize.get('https://www.walgreens.com/findcare/vaccination/covid-19')
      binding.pry
    end
  end
end
