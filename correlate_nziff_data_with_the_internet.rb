# for every film imported from the NZIFF site
# merge with data from RT and save

require_relative 'lib/film'
require_relative 'lib/review'
require_relative 'lib/rottentomatoes'
require_relative 'lib/nziff'

# retrieve a list of film names
nziff_films = Nziff.instance.imported

nziff_films.each do |nziff_film|
  puts "Search RT for #{nziff_film[:title]}"

  payload = RottenTomatoes.instance.search(q: nziff_film[:title])
  puts "\t#{payload[:total]} found"

  payload[:movies].each do |rt_film|
    puts "\t#{rt_film[:id]}\t#{rt_film[:year]}\t#{rt_film[:title]}\t#{rt_film[:synopsis]}"
    puts "\tSave this film? [Y,n,s(kip),q(uit)]"
    prompt = STDIN.gets.chomp.downcase
    if ["y", ""].include?(prompt)
      # TODO the image
      Film.new(rt_film.merge(nziff_film)).save
      break
    elsif prompt == "s"
      break
    elsif prompt == "q"
      exit
    else
      puts "\tSkipping"
    end
  end
end
