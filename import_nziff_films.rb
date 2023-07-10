# given a region String, scrape all data about a film from the NZIFF site.

require 'slop'

require_relative 'lib/nziff'

opts = Slop.parse do
  banner 'Usage: scrape_nziff_by_region.rb [options]'

  on 'r=', 'Region'
  on 'y=', 'Year', default: Time.now.year
  on 'x=', 'Also scrape existing', default: false
end

unless opts[:r]
  puts opts
  exit
end

nziff_import = NZIFF.new(region: opts[:r].downcase, year: opts[:y])
imported_slugs = NZIFF.imported(opts[:y]).map { |film| film['slug'] }

puts "#{nziff_import.films.count} found"

nziff_import.films.each do |film|
  if imported_slugs.include?(film.slug)
    puts "Skipping film with slug #{film.slug}, already imported"
    next
  end

  puts "Importing film with slug #{film.slug}"
  film.import!

  # Be a good internet citizen by pausing between requests
  sleep 3
end
