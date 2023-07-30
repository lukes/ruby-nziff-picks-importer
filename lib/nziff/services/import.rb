# frozen_string_literal: true

require 'fileutils'
require 'json'

module NZIFF
  class Import
    IMPORT_PATH = 'imported/films/nziff'

    def initialize(film)
      @film = film
    end

    class << self
      def prepare!
        FileUtils.mkdir_p(IMPORT_PATH)
      end

      def imported
        @imported ||= Dir.glob("#{IMPORT_PATH}/*.json").map do |f|
          JSON.parse(File.read(f))
        end
      end
    end

    def call
      film_data = film_from_page
      path = "#{self.class::IMPORT_PATH}/#{film.slug}.json"

      File.open(path, 'w') do |f|
        f.write(JSON.generate(film_data))
      end
    end

    private

    attr_reader :film

    def film_from_page
      page = Request.call("#{film.region}/#{film.slug}", year: film.year)

      {
        scraped: Time.now,
        tag: page.css('.category-label')[0]&.text,
        title: page.css('.article-title').xpath("span[@itemprop='name']").text,
        title_extra: page.css('.title-extra').text,
        director: page.css("a[@itemprop='director']").text,
        year: film.year.to_i,
        region: film.region,
        slug: film.slug,
        nziff_url: Request.uri("#{film.region}/#{film.slug}", year: film.year),
        trailer: page.css('a[@data-trailer-id]').attr('href')&.value
      }
    end
  end
end
