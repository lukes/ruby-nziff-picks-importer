require 'json'
require 'open-uri'
require 'singleton'
require 'yaml'

class OMDb
  include Singleton

  def image(title)
    request(title)['Poster']
  end

private

  def request(title)
    uri = URI::encode("http://www.omdbapi.com/?t=#{title}&y=&plot=short&r=json")
    # uri = URI::encode(api_root + path)
    JSON.parse(open(uri).read)
  end

end
