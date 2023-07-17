# frozen_string_literal: true

require 'active_support/core_ext/hash'
require 'json'

module NZIFF
  class Search
    def initialize(region:, year: Time.now.year)
      @region = region
      @year = year
    end

    def call
      page = Request.call("#{region}/films/title/", year: year)

      page.css('[itemprop=url]').map do |a|
        slug = a.attributes['href'].value.sub(%r{.+#{region}/(.+)/}, '\1')

        Film.new(slug: slug, year: year, region: region)
      end
    end

    private

    attr_reader :region, :year
  end
end
