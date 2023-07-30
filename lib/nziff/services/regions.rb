# frozen_string_literal: true

module NZIFF
  class Regions
    def initialize(year)
      @year = year
    end

    def call
      page = Request.call('', year: year)

      page.css('[itemtype="http://schema.org/Event"]').map do |region|
        slug = region.css('[itemprop=url]').attr('href').value[%r{\d+/(.+)/}, 1]
        name = region.css('[itemprop=location]').text
        dates = region.css('.duration').text

        Region.new(name: name, slug: slug, dates: dates)
      end
    end

    private

    attr_reader :year
  end
end
