# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/rotten_tomatoes/**/*.rb"].sort.each { |file| require file }

module RottenTomatoes; end
