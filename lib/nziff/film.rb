require 'request'

class NZIFF
  class Film
    include Request

    IMPORT_PATH = 'imported/films/nziff'

    attr_reader :slug

    def initialize(region:, year:, slug:)
      @region = region
      @year = year
      @slug = slug
    end

    def import!
      page = request("#{region}/#{slug}")

      film = {

      }

      film[:scraped] = Time.now
      film[:tag] = page.css(".category-label")[0].text
      film[:title] = page.css(".article-title").xpath("span[@itemprop='name']").text
      film[:year] = page.css(".article-title").xpath("span[@itemprop='copyrightYear']").text
      film[:slug] = slug
      film[:imdb_uri] = page.xpath("//a[text()[contains(.,'IMDb')]]").attr("href").value rescue nil

      puts "Saving film"
      File.open("#{IMPORT_PATH}/#{slug}.json", 'w') {|f| f.write(JSON.generate(film)) }
    end

    private

    attr_reader :region, :year
  end
end
