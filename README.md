ruby-nziff-picks-importer
=========================

Ruby library to import film data from the New Zealand International
Film Festival, and review sites.

## Installation

Install the Ruby gems:

```bash
bundle
```

## Use

```bash
bundle exec ruby scripts/import_nziff_films.rb --help
bundle exec ruby scripts/import_rt_reviews.rb --help
```

Example:

```bash
bundle exec ruby scripts/import_nziff_films.rb --region tamaki-makaurau-auckland
bundle exec ruby scripts/import_rt_reviews.rb
```
