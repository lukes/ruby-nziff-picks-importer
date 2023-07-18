# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/nziff/**/*.rb"].sort.each { |file| require file }

module NZIFF; end
