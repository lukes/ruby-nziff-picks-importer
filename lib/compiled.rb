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
    def filtered(filter:, page:, rows:, sort:, sort_direction:)
      set = films
      set = apply_filter(set, filter)
      set = apply_sort(set, sort)
      set = apply_sort_direction(set, sort_direction)
      apply_rows(set, page, rows)
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

    def apply_filter(set, filter)
      return set if filter.nil? || filter.strip == ''

      set.select { |film| film['title'].downcase.match(filter.downcase) }
    end

    def apply_sort(set, sort)
      set.sort_by { |film| film[sort] }
    rescue ArgumentError # Temporary
      set.sort_by { |film| film[sort].to_i }
    end

    def apply_sort_direction(set, sort_direction)
      set.reverse! if sort_direction == 'desc'
      set
    end

    def apply_rows(set, page, rows)
      start_i = (page - 1) * rows
      end_i = start_i + rows - 1

      set[start_i..end_i] || []
    end
  end
end
