require 'active_support/core_ext/hash'
require 'json'
require 'nokogiri'
# require 'singleton'
require 'yaml'

lib = File.expand_path('nziff', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'film'
require 'request'

class NZIFF
  include Request

  def initialize(region:, year: Time.now.year)
    @region = region
    @year = year
  end

  def films
    @films ||= begin
      page = request("#{region}/films/title/")

      page.css("[itemprop=url]").map do |a|
        slug = a.attributes['href'].value.sub(/.+#{region}\/(.+)\//, '\1')

        Film.new(slug: slug, year: year, region: region)
      end
    end
  end

  def self.imported
    Dir.glob("#{Film.import_path(year)}/*.json").map do |f|
      JSON.parse(File.read(f)).with_indifferent_access
    end
  end

  private

  attr_reader :year, :region
end
