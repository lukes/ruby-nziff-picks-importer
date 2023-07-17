# frozen_string_literal: true

module RottenTomatoes
  class SearchResult
    attr_reader :title, :url, :year

    def initialize(title:, url:, year:)
      @title = title
      @url = url
      @year = year
    end
  end
end
