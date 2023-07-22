# frozen_string_literal: true

require 'json'

require_relative 'nziff'
require_relative 'rottentomatoes'

class Compiled
  NZIFF_FILM_PROPERTIES = %w[
    title
    trailer
  ].freeze

  RT_FILM_PROPERTIES = %w[
    audience_score
    critic_score
  ].freeze

  class << self
    def as_table(sort:, sort_direction:, rows:)
      table = apply_sort(sort)
      table = apply_sort_direction(table, sort_direction)
      table = apply_rows(table, rows)

      table.map do |film|
        [film['title'], film['critic_score'], film['trailer']]
      end
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
    end

    def apply_sort_direction(table, sort_direction)
      return table.reverse if sort_direction == 'desc'

      table
    end

    def apply_rows(table, rows)
      table[0..rows]
    end
  end
end
