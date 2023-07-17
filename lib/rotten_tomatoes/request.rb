# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module RottenTomatoes
  module Request
    HOST = 'https://www.rottentomatoes.com'

    def self.call(path)
      uri = [HOST, path].join

      Nokogiri::HTML(URI.parse(uri).open.read)
    end
  end
end
