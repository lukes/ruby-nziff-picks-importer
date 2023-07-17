# frozen_string_literal: true

require 'slop'

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

def prompt!(results)
  puts

  if results.count == 1
    puts "\tImport film? [Y,s(kip),q(uit)]"
  else
    puts "\tImport which film? [1-#{results.count},s(kip),q(uit)]"
  end

  $stdin.gets.chomp.downcase
end

# rubocop: disable Metrics/MethodLength
def handle_prompt!(prompt, results, slug)
  case prompt
  when 'Y', 'y', ''
    result = results[0]
  when /\d/
    result = results[prompt.to_i - 1]
  when 'q'
    exit
  end

  return unless result

  RottenTomatoes::Import.new(result, slug: slug).call
  puts "\tImported!"
end
# rubocop: enable Metrics/MethodLength

nziff_films = NZIFF::Import.imported
imported_slugs = RottenTomatoes::Import.imported.map { _1['nziff_slug'] }

nziff_films.each do |nziff_film|
  director, slug, title, year = nziff_film.values_at('director', 'slug', 'title', 'year')

  next if opts[:'start-from'] && slug < opts[:'start-from']

  if !opts[:replace] && imported_slugs.include?(slug)
    puts "Skipping #{title}, already imported"
    next
  end

  puts "Searching for #{title}, #{year}"

  results = RottenTomatoes::Search.new(title: title, director: director).call

  puts "\tFound:"

  results.each_with_index do |result, i|
    puts "\t\t[#{i + 1}] #{result.title}, #{result.year}"
  end

  if results.count.zero?
    puts "\tNo results found"
    next
  end

  prompt = prompt!(results)
  handle_prompt!(prompt, results, slug)
end
