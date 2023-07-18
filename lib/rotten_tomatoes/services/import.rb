# frozen_string_literal: true

module RottenTomatoes
  class Import
    IMPORT_PATH = 'imported/films/rotten_tomatoes'
    REVIEW_PATH = '%<path>s/reviews?type=top_critics&sort=%<sort>s'

    def initialize(search_result, slug:)
      @title = search_result.title
      @path = URI.parse(search_result.url).path
      @year = search_result.year
      @slug = slug
    end

    def self.imported
      Dir.glob("#{IMPORT_PATH}/*.json").map do |f|
        JSON.parse(File.read(f))
      end
    end

    def call
      film = film_from_page
      file_path = "#{IMPORT_PATH}/#{slug}.json"

      File.open(file_path, 'w') do |f|
        f.write(JSON.generate(film))
      end
    end

    private

    attr_reader :path, :slug, :title, :year

    # rubocop: disable Metrics/MethodLength
    def film_from_page
      page = Request.call(path)

      scores = page.css('score-board')
      audience_score = scores.attr('audiencescore').value
      critic_score = scores.attr('tomatometerscore').value

      {
        scraped: Time.now,
        title: title,
        path: path,
        year: year,
        nziff_slug: slug,
        audience_score: audience_score.to_i,
        critic_score: critic_score.to_i,
        bad_review: bad_review,
        good_review: good_review
      }
    end
    # rubocop: enable Metrics/MethodLength

    def bad_review
      page = Request.call(format(REVIEW_PATH, path: path, sort: 'rotten'))

      extract_quote(page)
    end

    def good_review
      page = Request.call(format(REVIEW_PATH, path: path, sort: 'fresh'))

      extract_quote(page)
    end

    def extract_quote(page)
      page.css('[data-qa=review-quote]')[0]&.text
    end
  end
end
