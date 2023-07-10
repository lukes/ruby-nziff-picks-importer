require 'nokogiri'
require 'open-uri'

class NZIFF
  module Request
    HOST = 'https://www.nziff.co.nz'

    private

    def request(path)
      uri = [HOST, (year || Time.now.year.to_s), path].join('/')

      Nokogiri::HTML(URI.open(uri).read)
    end
  end
end
