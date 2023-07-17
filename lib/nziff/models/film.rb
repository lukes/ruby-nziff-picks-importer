# frozen_string_literal: true

module NZIFF
  class Film
    attr_reader :region, :slug, :year

    def initialize(region:, year:, slug:)
      @region = region
      @year = year
      @slug = slug
    end
  end
end
