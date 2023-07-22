# frozen_string_literal: true

require 'json'

require_relative 'nziff'
require_relative 'rottentomatoes'

class Compiled
  class << self
    def films
      nziff_films.map do |film|
        merge_with_rt(film)
      end
    end

    private

    def nziff_films
      @nziff_films ||= NZIFF::Import.imported
    end

    def rt_films
      @rt_films ||= RottenTomatoes::Import.imported
    end

    def merge_with_rt(film)
      slug = film['slug']
      rt_film = rt_films.find { |f| f['nziff_slug'] == slug }
      rt_film ||= {} # No RT found

      film.merge(rt_film)
    end
  end
end
