# frozen_string_literal: true

require 'fileutils'
require 'slop'
require 'tty-progressbar'
require 'tty-prompt'

require_relative '../lib/nziff'

opts = Slop.parse do |o|
  o.bool '-h', '--help', 'Help'
  o.string '-r', '--region', 'Region'
  o.integer '-y', '--year', 'Year', default: Time.now.year
  o.bool '-x', '--replace', 'Replace imported', default: false
end

if opts[:help]
  puts opts
  exit
end

region = opts[:region]
year = opts[:year]

if region.nil?
  options = NZIFF::Regions.new(year).call.map do |r|
    { name: r.name, value: r.slug }
  end

  prompt = TTY::Prompt.new
  region = prompt.select('Select a region to import:', options, filter: true, per_page: options.length + 1)
end

FileUtils.mkdir_p(NZIFF::Import::IMPORT_PATH)

films = NZIFF::Search.new(region: region.downcase, year: year).call
imported_slugs = NZIFF::Import.imported.map { _1['slug'] }

puts "#{films.count} found"

bar = TTY::ProgressBar.new('Downloading [:bar] :current/:total', total: films.count, clear: true)

films.each do |film|
  bar.advance

  if !opts[:replace] && imported_slugs.include?(film.slug)
    bar.log("Skipping film with slug #{film.slug}, already imported")

    next
  end

  bar.log("Importing film with slug #{film.slug}")

  NZIFF::Import.new(film).call

  # Be a good internet citizen by pausing between requests
  sleep 1
end

bar.finish
puts 'Finished'
