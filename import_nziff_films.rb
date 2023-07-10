# given a region String, scrape all data about a film from the NZIFF site.

require 'slop'

require_relative 'lib/nziff'

opts = Slop.parse do
  banner 'Usage: scrape_nziff_by_region.rb [options]'

  on 'r=', 'Region'
  on 'y=', 'Year'
  on 'x=', 'Also scrape existing'
end

unless opts[:r]
  puts opts
  exit
end

nziff_import = NZIFF.new(region: opts[:r].downcase, year: opts[:y])

# TODO unless -x is true, reject the film_slugs of things we've already scraped

puts "#{nziff_import.films.count} found"

nziff_import.films.each do |film|
  puts "Importing film with slug #{film.slug}"
  film.import!

  # Be a good internet citizen by pausing between requests
  sleep 3
end
