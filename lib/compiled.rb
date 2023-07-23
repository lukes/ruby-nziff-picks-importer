# frozen_string_literal: true

require 'json'
require 'tty-link'

require_relative 'nziff'
require_relative 'rottentomatoes'

LINK = TTY::Link

class Compiled
  NZIFF_FILM_PROPERTIES = %w[
    title
    trailer
  ].freeze

  RT_FILM_PROPERTIES = %w[
    audience_score
    bad_review
    critic_score
    good_review
  ].freeze

  class << self
    def filtered(sort:, sort_direction:, rows:)
      set = apply_sort(sort)
      set.reverse! if sort_direction == 'desc'
      set[0..rows]
    end

    def films
      @films ||= nziff_films.map do |film|
        compile_with_rt_film(film)
      end
    end

    private

    def nziff_films
      NZIFF::Import.imported
    end

    def rt_films
      RottenTomatoes::Import.imported
    end

    def compile_with_rt_film(nziff_film)
      slug = nziff_film['slug']
      rt_film = rt_films.find { |f| f['nziff_slug'] == slug }
      rt_film ||= {} # No RT film found

      nziff_film.slice(*NZIFF_FILM_PROPERTIES).merge(rt_film.slice(*RT_FILM_PROPERTIES))
    end

    def apply_sort(sort)
      films.sort_by { |film| film[sort] }
    rescue ArgumentError # Temporary
      films.sort_by { |film| film[sort].to_i }
    end
  end
end
