# frozen_string_literal: true

require 'active_support/core_ext/hash'
Dir["#{File.dirname(__FILE__)}/nziff/**/*.rb"].sort.each { |file| require file }

module NZIFF; end
