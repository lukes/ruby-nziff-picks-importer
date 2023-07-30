# frozen_string_literal: true

module NZIFF
  class Region
    attr_reader :dates, :name, :slug

    def initialize(dates:, name:, slug:)
      @dates = dates
      @name = name
      @slug = slug
    end
  end
end
