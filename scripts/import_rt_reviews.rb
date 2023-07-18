# frozen_string_literal: true

require 'slop'
require 'tty-prompt'

require_relative '../lib/nziff'
require_relative '../lib/rottentomatoes'

opts = Slop.parse do |o|
  o.string '-h', '--help', 'Help'
  o.string '-s', '--start-from', 'Start from (slug)'
  o.bool '-x', '--replace', 'Replace imported', default: false
end

if opts[:help]
  puts opts
  exit
end

prompt = TTY::Prompt.new

# rubocop: disable Metrics/AbcSize
# rubocop: disable Metrics/MethodLength
def prompt!(results)
  case results.count
  when 0
    prompt.say('No results found')
  when 1
    result = results.first
    prompt.yes?("Import #{result.title}, #{result.year}?") == true
  else
    prompt_options = results.each_with_index.map { |r, i| { "#{r.title}, #{r.year}" => i } }
    prompt_options << { 'Skip this' => results.count }

    answer = prompt.select(
      "Found #{results.count} results. Import which film?",
      prompt_options,
      per_page: results.count + 1
    )

    results[answer]
  end
end
# rubocop: enable Metrics/AbcSize
# rubocop: enable Metrics/MethodLength

nziff_films = NZIFF::Import.imported
imported_slugs = RottenTomatoes::Import.imported.map { _1['nziff_slug'] }

nziff_films.each do |nziff_film|
  director, slug, title, year = nziff_film.values_at('director', 'slug', 'title', 'year')

  next if opts[:'start-from'] && slug < opts[:'start-from']

  if !opts[:replace] && imported_slugs.include?(slug)
    prompt.say("Skipping #{title}, already imported")
    next
  end

  prompt.say("Searching for #{title}, #{year}", color: :blue)

  results = RottenTomatoes::Search.new(title: title, director: director).call
  answer = prompt!(results)

  if answer
    RottenTomatoes::Import.new(answer, slug: slug).call
    prompt.ok('Imported!')
  end
end
