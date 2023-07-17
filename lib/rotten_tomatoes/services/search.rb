# frozen_string_literal: true

require 'nokogiri'
require 'pry'

module RottenTomatoes
  class Search
    SEARCH_PATH = '/search?search=%<search>s'

    def initialize(director:, title:)
      @director = director
      @title = title
    end

    def call
      page = Request.call(search_path)

      results = page.css('search-page-result[type="movie"] search-page-media-row')

      results.map do |result|
        title_node = result.css('a[slot=title]')

        result_title = title_node.text.strip
        result_url = title_node.attr('href').value
        result_year = result.attr('releaseyear').to_i

        SearchResult.new(title: result_title, url: result_url, year: result_year)
      end
    end

    private

    attr_reader :director, :title

    def search_path
      format(SEARCH_PATH, search: CGI.escape("#{title} #{director}"))
    end
  end
end
