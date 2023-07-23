# frozen_string_literal: true

require 'json'
require 'tty-link'

require_relative 'nziff'
require_relative 'rottentomatoes'

LINK = TTY::Link

class Compiled
  NZIFF_FILM_PROPERTIES = %w[
    slug
    title
    trailer
  ].freeze

  RT_FILM_PROPERTIES = %w[
    audience_score
    bad_review
    critic_score
    good_review
  ].freeze

  HIGHLIGHT_PATH = 'highlighted'

  class << self
    def filtered(filter:, page:, rows:, show_only_highlights:, sort:, sort_direction:)
      set = films
      set = apply_filter(set, filter)
      set = apply_show_only_highlights(set, show_only_highlights)
      set = apply_sort(set, sort)
      set = apply_sort_direction(set, sort_direction)
      apply_rows(set, page, rows)
    end

    def films
      @films ||= nziff_films.map do |film|
        compile_with_rt_film(film)
      end
    end

    def toggle_highlight!(film)
      FileUtils.mkdir_p(HIGHLIGHT_PATH)

      path = File.join(HIGHLIGHT_PATH, film['slug'])
      return FileUtils.rm(path) if File.exist?(path)

      FileUtils.touch(path)
    end

    def highlighted?(film)
      path = File.join(HIGHLIGHT_PATH, film['slug'])
      File.exist?(path)
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

    def apply_show_only_highlights(set, show_only_highlights)
      return set unless show_only_highlights

      set.select { |film| highlighted?(film) }
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
