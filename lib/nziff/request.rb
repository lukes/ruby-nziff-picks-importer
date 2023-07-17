# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module NZIFF
  module Request
    HOST = 'https://www.nziff.co.nz'

    def self.call(path, year: Time.now.year.to_s)
      uri = [HOST, year, path].join('/')

      Nokogiri::HTML(URI.parse(uri).open.read)
    end
  end
end
