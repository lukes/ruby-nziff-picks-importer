# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module NZIFF
  module Request
    HOST = 'https://www.nziff.co.nz'

    def self.call(path, year: Time.now.year.to_s)
      uri = uri(path, year: year)

      Nokogiri::HTML(URI.parse(uri).open.read)
    end

    def self.uri(path, year: Time.now.year.to_s)
      [HOST, year, path].join('/')
    end
  end
end
