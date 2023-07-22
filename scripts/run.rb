# frozen_string_literal: true

require 'tty-link'
require 'tty-prompt'
require 'tty-table'


require_relative '../lib/compiled'

CHOICES_SORT = %w[critic_score title].freeze
CHOICES_SORT_DIRECTION = %w[asc desc].freeze
TABLE_HEADER = %w[Title Score Trailer].freeze
# Option to show/hide table headers?

DEFAULT_OPTIONS = {
  sort: 'critic_score',
  sort_direction: 'desc',
  rows: 20
}.freeze

PROMPT = TTY::Prompt.new(quiet: true)

MENU_OPTIONS = [
  { key: 's', name: 'Change sort by', value: :sort },
  { key: 'd', name: 'Change sort direction', value: :sort_direction },
  { key: 'r', name: 'Change number of rows', value: :rows },
  { key: 'q', name: 'Quit', value: :quit }
].freeze

def prompt_which_key?
  PROMPT.expand('Change table:', MENU_OPTIONS)
end

def prompt_which_value?(option_key)
  return PROMPT.ask('Change number of rows to:', convert: :int) if option_key == :rows

  options = case option_key
            when :sort
              CHOICES_SORT
            when :sort_direction
              CHOICES_SORT_DIRECTION
            end

  PROMPT.select('Which option?', options)
end

def prompt(options)
  PROMPT.say("Showing #{options[:rows]}/#{Compiled.films.count} films")

  option_key = prompt_which_key?
  exit if option_key == :quit

  option_value = prompt_which_value?(option_key)

  options[option_key] = option_value

  draw(options)
end

def draw(options = DEFAULT_OPTIONS.dup)
  table = TTY::Table.new(header: TABLE_HEADER, rows: Compiled.as_table(**options), padding: 1)
  puts table.render(:unicode, multiline: true)

  prompt(options)
end

draw
