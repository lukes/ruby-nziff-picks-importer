# frozen_string_literal: true

require 'tty-prompt'
require 'tty-table'
require 'fileutils'

require 'pry'

require_relative '../lib/compiled'
require_relative '../lib/nziff'

CHOICES_SORT = %w[audience_score critic_score title].freeze
CHOICES_SORT_DIRECTION = %w[asc desc].freeze
TABLE_HEADER = ['Title', 'Audience Score', 'Critics Score', 'Has Reviews?', 'Trailer'].freeze

DEFAULT_OPTIONS = {
  sort: 'critic_score',
  sort_direction: 'desc',
  rows: 20,
  filter: '',
  page: 1,
  show_only_highlights: false
}.freeze

PROMPT = TTY::Prompt.new(quiet: true)
PASTEL = Pastel.new

PROMPT_OPTIONS_TABLE = [
  { name: 'Change sort by', value: :sort },
  { name: 'Change sort direction', value: :sort_direction },
  { name: 'Change number of rows', value: :rows }
].freeze

def prompt(options)
  PROMPT.say("Showing #{Compiled.filtered(**options).count}/#{Compiled.films.count} films")

  prompt_options = prompt_options(options)
  answer = PROMPT.select('What next?', prompt_options, per_page: prompt_options.count)

  case answer
  when :quit
    exit
  when :inspect
    prompt_inspect_which_film?(options)
  when :filter
    options[:show_only_highlights] = false
    options[:page] = 1
    prompt_filter_table(options)
  when :highlight
    prompt_highlight(options)
  when :toggle_only_highlights
    options[:show_only_highlights] = !options[:show_only_highlights]
    options[:filter] = ''
    options[:page] = 1
    draw(options)
  when :next
    options[:page] += 1
    draw(options)
  when :previous
    options[:page] -= 1 unless options[:page] == 1
    draw(options)
  else
    prompt_change_table(options)
  end
end

# rubocop: disable Metrics/MethodLength
def prompt_options(options)
  prompt_options = []
  next_page_options = options.merge(page: options[:page] + 1)

  prompt_options << { name: 'Next page', value: :next } if Compiled.filtered(**next_page_options).count.positive?
  prompt_options << { name: 'Previous page', value: :previous } unless options[:page] == 1

  toggle_highlight_text = if options[:show_only_highlights]
    '✓ Showing only highlights'
  else
    '✗ Not showing only highlights'
  end

  prompt_options.push(
    { name: 'Inspect a film', value: :inspect },
    { name: 'Search by title', value: :filter },
    { name: toggle_highlight_text, value: :toggle_only_highlights },
    { name: 'Add/remove highlight on film', value: :highlight },
    { name: 'Change table sort/rows', value: :prompt },
    { name: 'Quit', value: :quit }
  )
end
# rubocop: enable Metrics/MethodLength

def prompt_filter_table(options)
  answer = PROMPT.ask('Filter by name (hit return for no filter):')

  options[:filter] = answer
  options[:page] = 1

  draw(options)
end

def prompt_highlight(options)
  films = Compiled.filtered(**options)
  film_options = films.each_with_index.map do |film, i|
    { name: film['title'], value: i }
  end

  answer = PROMPT.select('Toggle highlight on which film?', film_options, per_page: options[:rows] + 1, filter: true)
  toggle_highlight_film!(films[answer])

  draw(options)
end

def prompt_inspect_which_film?(options)
  films = Compiled.filtered(**options)
  film_options = films.each_with_index.map do |film, i|
    { name: film['title'], value: i }
  end

  answer = PROMPT.select('Which film?', film_options, per_page: options[:rows] + 1, filter: true)

  inspect_film(options, films[answer])
end

def prompt_change_table(options)
  option_key = prompt_change_table_which_key?
  exit if option_key == :quit

  option_value = prompt_change_table_which_value?(option_key)

  options[option_key] = option_value

  draw(options)
end

def prompt_change_table_which_key?
  PROMPT.select('Change table:', PROMPT_OPTIONS_TABLE)
end

def prompt_change_table_which_value?(option_key)
  return PROMPT.ask('Change number of rows to:', convert: :int) if option_key == :rows

  options = case option_key
            when :sort
              CHOICES_SORT
            when :sort_direction
              CHOICES_SORT_DIRECTION
            end

  PROMPT.select('Which option?', options)
end

def films_to_rows(films)
  films.map do |film|
    reviews = []
    reviews << '✓Good' if film['good_review']
    reviews << '✓Bad' if film['bad_review']

    title = film['title']
    title = PASTEL.white.on_blue(title) if highlighted?(film)

    [
      title,
      film['audience_score'],
      film['critic_score'],
      reviews.join(' '),
      film['trailer']
    ]
  end
end

def highlighted?(film)
  Compiled.highlighted?(film)
end

def draw(options = DEFAULT_OPTIONS.dup)
  rows = films_to_rows(Compiled.filtered(**options))
  table = TTY::Table.new(header: TABLE_HEADER, rows: rows)

  system 'clear'
  puts table.render(:unicode, multiline: true, resize: true)

  prompt(options)
end

# rubocop: disable Metrics/AbcSize
# rubocop: disable Metrics/MethodLength
def inspect_film(options, film)
  title = film['title']
  title += " (#{film['title_extra']})" if film['title_extra'] != ''

  rows = [
    ['Title', title],
    ['Director', film['director']],
    ['Year', film['year']],
    ['Tag', film['tag']],
    ['Critic Score', film['critic_score']],
    ['Audience Score', film['audience_score']],
    ['Good review', word_wrap(film['good_review'])],
    ['Bad review', word_wrap(film['bad_review'])],
    ['Trailer', film['trailer']],
    ['NZ Film Fest page', film['nziff_url']],
    ['Rotten tomatoes page', "https://www.rottentomatoes.com#{film['path']}"]
  ]

  table = TTY::Table.new(rows: rows, padding: 1)

  system 'clear'
  puts table.render(:unicode, multiline: true) do |renderer|
    renderer.border.separator = :each_row
  end

  PROMPT.keypress(PASTEL.white.on_blue('Press to return'))

  draw(options)
end
# rubocop: enable Metrics/AbcSize
# rubocop: enable Metrics/MethodLength

def word_wrap(text, width: 80)
  return unless text

  text.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
end

def toggle_highlight_film!(film)
  Compiled.toggle_highlight!(film)
end

draw
