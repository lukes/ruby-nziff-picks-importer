ruby-nziff-picks-importer
=========================

Ruby library to import film data from the New Zealand International
Film Festival, and correlate it with review scores from Rotten Tomatoes
to help you decide which films to watch.

```
┌────────────────────┬─────┬───────────────────────────────────────────┐
│Title               │Score│Trailer                                    │
├────────────────────┼─────┼───────────────────────────────────────────┤
│Fallen Leaves       │100  │                                           │
│Charcoal            │100  │https://www.youtube.com/watch?v=qaxw60-NW4U│
│On The Adamant      │100  │https://www.youtube.com/watch?v=sEPMTTQt-48│
│Chop & Steele       │100  │https://www.youtube.com/watch?v=w235aQ2eEmg│
│Pictures of Ghosts  │100  │https://www.youtube.com/watch?v=Vi19G7_HfxQ│
│Tiger Stripes       │100  │https://www.youtube.com/watch?v=Q7lu0KoD5so│
│Pray for Our Sinners│100  │https://www.youtube.com/watch?v=wR1OvhIrqls│
│Close to Vermeer    │100  │https://www.youtube.com/watch?v=6KiuUSA1Z94│
│Inshallah a Boy     │100  │                                           │
│The Settlers        │100  │                                           │
│Perfect Days        │100  │https://www.youtube.com/watch?v=HTgWYojq-z8│
└────────────────────┴─────┴───────────────────────────────────────────┘
Showing 10/142 films
Change table:
  s - Change sort by
  d - Change sort direction
  r - Change number of rows
  q - Quit
  h - print help
```

## Installation

Install the Ruby gems:

```bash
bundle
```

## Use

First, import data from the NZ Film Festival website, and Rotten Tomatoes. Pass `--help` to each script to see the options:

```bash
bundle exec ruby scripts/import_nziff_films.rb --help
bundle exec ruby scripts/import_rt_reviews.rb --help
```

Example, to import film data for Auckland:

```bash
bundle exec ruby scripts/import_nziff_films.rb --region tamaki-makaurau-auckland
```

And then import the Rotten Tomatoes review scores for those films:

```bash
bundle exec ruby scripts/import_rt_reviews.rb
```

Next, run the app:

```bash
bundle exec ruby scripts/run.rb
```
