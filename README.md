ruby-nziff-picks-importer
=========================

Ruby library to import film data from the New Zealand International
Film Festival, and correlate it with review scores from Rotten Tomatoes
to help you decide which films to watch.

```
┌────────────────────────────────────┬─────────────────┬───────────────┬──────────────┬─────────────────────────────────────────────┐
│Title                               │Audience Score   │Critics Score  │Has Reviews?  │Trailer                                      │
├────────────────────────────────────┼─────────────────┼───────────────┼──────────────┼─────────────────────────────────────────────┤
│Fallen Leaves                       │0                │100            │✓Good         │                                             │
│Charcoal                            │0                │100            │✓Good         │https://www.youtube.com/watch?v=qaxw60-NW4U  │
│On The Adamant                      │0                │100            │✓Good         │https://www.youtube.com/watch?v=sEPMTTQt-48  │
│Chop & Steele                       │0                │100            │✓Good ✓Bad    │https://www.youtube.com/watch?v=w235aQ2eEmg  │
│Pictures of Ghosts                  │0                │100            │✓Good         │https://www.youtube.com/watch?v=Vi19G7_HfxQ  │
│Tiger Stripes                       │0                │100            │✓Good         │https://www.youtube.com/watch?v=Q7lu0KoD5so  │
│Pray for Our Sinners                │0                │100            │✓Good ✓Bad    │https://www.youtube.com/watch?v=wR1OvhIrqls  │
│Close to Vermeer                    │98               │100            │✓Good         │https://www.youtube.com/watch?v=6KiuUSA1Z94  │
│Inshallah a Boy                     │0                │100            │✓Good         │                                             │
│The Settlers                        │0                │100            │✓Good         │                                             │
│Perfect Days                        │0                │100            │✓Good         │https://www.youtube.com/watch?v=HTgWYojq-z8  │
│Robot Dreams                        │0                │100            │✓Good         │                                             │
│Kokomo City                         │0                │100            │✓Good         │https://www.youtube.com/watch?v=JdM2voAE-ok  │
│My Name Is Alfred Hitchcock         │0                │100            │✓Good         │https://www.youtube.com/watch?v=OfanYi3LPLQ  │
│Bobi Wine: The People’s President   │0                │100            │✓Good         │                                             │
│Late Night with the Devil           │0                │100            │✓Good         │                                             │
│I Like Movies                       │0                │100            │✓Good         │https://www.youtube.com/watch?v=godMZzeWTu0  │
│Smoke Sauna Sisterhood              │80               │100            │✓Good         │https://vimeo.com/819473014                  │
│Ennio                               │100              │100            │✓Good ✓Bad    │https://www.youtube.com/watch?v=FEVJsaTJLZw  │
│Mami Wata                           │0                │100            │✓Good ✓Bad    │                                             │
└────────────────────────────────────┴─────────────────┴───────────────┴──────────────┴─────────────────────────────────────────────┘
Showing 20/142 films
What next? (Press ↑/↓ arrow to move and Enter to select)
‣ Next page
  Inspect a film
  Search by title
  ✗ Not showing only favourites
  Add/remove highlight on film
  Change table sort/rows
  Quit
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

### Features:

- See films correlated with reviews and ratings
- Watch trailers
- Mark a film as a favourite to highlight it in table
- Search by title
- Sort by ratings or title
- Inspect films to see more data
