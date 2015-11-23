# compiles saved data into ember fixtures
require 'active_support/json'
require 'active_support/core_ext/hash'

PATH = File.dirname(__FILE__)

# retrieve data from files
films = Dir.glob(File.join(PATH, 'imported/films/rotten_tomatoes', '*.json')).map do |f|
  ActiveSupport::JSON.decode(File.read(f)).with_indifferent_access
end

reviews = Dir.glob(File.join(PATH, 'imported/reviews/rotten_tomatoes', '*.json')).map do |f|
  ActiveSupport::JSON.decode(File.read(f)).with_indifferent_access
end

# write data
File.open(File.join(PATH, 'compiled', 'data.js'), 'w+') do |f|
  data = {}
  data[:films] = films
  data[:reviews] = reviews
  f.write(ActiveSupport::JSON.encode(data))
end
