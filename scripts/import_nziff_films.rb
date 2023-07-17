# frozen_string_literal: true

require 'slop'

require_relative '../lib/nziff'

opts = Slop.parse do |o|
  o.string '-h', '--help', 'Help'
  o.string '-r', '--region', 'Region'
  o.integer '-y', '--year', 'Year', default: Time.now.year
  o.bool '-x', '--replace', 'Replace imported', default: false
end

if opts[:region].nil? || opts[:help]
  puts opts
  exit
end

films = NZIFF::Search.new(region: opts[:region].downcase, year: opts[:year]).call
imported_slugs = NZIFF::Import.imported.map { _1['slug'] }

puts "#{films.count} found"

films.each do |film|
  if !opts[:replace] && imported_slugs.include?(film.slug)
    puts "Skipping film with slug #{film.slug}, already imported"
    next
  end

  puts "Importing film with slug #{film.slug}"
  NZIFF::Import.new(film).call

  # Be a good internet citizen by pausing between requests
  sleep 1
end
