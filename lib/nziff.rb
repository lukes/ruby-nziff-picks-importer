require 'active_support/core_ext/hash'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'singleton'
require 'yaml'

class Nziff
  include Singleton

  # returns all slugs for films in the given region
  def fetch_slugs_by_region(region)
    page = request("#{region}/films/title/")

    page.css("[itemprop=url]").map do |a|
      a.attributes['href'].value.sub(/.+#{region}\/(.+)\//, '\1')
    end
  end

  def import(region, slug)
    page = request("#{region}/#{slug}")

    film = {}.with_indifferent_access

    film[:scraped] = Time.now
    film[:tag] = page.css(".category-label")[0].text
    film[:title] = page.css(".article-title").xpath("span[@itemprop='name']").text
    film[:year] = page.css(".article-title").xpath("span[@itemprop='copyrightYear']").text
    film[:slug] = slug
    film[:imdb_uri] = page.xpath("//a[text()[contains(.,'IMDb')]]").attr("href").value rescue nil

    puts "Saving film"
    File.open("imported/films/nziff/#{slug}.json", 'w') {|f| f.write(JSON.generate(film)) }
  end

  def imported
    Dir.glob('imported/films/nziff/*.json').map do |f|
      JSON.parse(File.read(f)).with_indifferent_access
    end
  end

private

  def request(path)
    uri = nziff_2014_root + path
    Nokogiri::HTML(open(uri))
  end

  def nziff_2014_root
    "http://www.nziff.co.nz/2014/"
  end

end
