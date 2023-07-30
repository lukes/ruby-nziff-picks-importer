ruby-nziff-picks-importer
=========================

Ruby library to import film data from the New Zealand International
Film Festival, and correlate it with review scores from Rotten Tomatoes
to help you decide which films to watch.

```
┌──────────────────────────────────────┬───────────────┬──────────────┬─────────────┬───────────────────────────────────────────┐
│Title                                 │Audience Score │Critics Score │Has Reviews? │Trailer                                    │
├──────────────────────────────────────┼───────────────┼──────────────┼─────────────┼───────────────────────────────────────────┤
│Beyond Utopia                         │0              │100           │✓Good        │                                           │
│Are You There God? It's Me, Margaret. │95             │99            │✓Good ✓Bad   │https://www.youtube.com/watch?v=LzRzojHC3iE│
│No Bears                              │79             │99            │✓Good        │https://www.youtube.com/watch?v=ET9JtKgN3AA│
│Detour                                │78             │98            │✓Good ✓Bad   │https://vimeo.com/298248395                │
│Past Lives                            │93             │98            │✓Good ✓Bad   │https://www.youtube.com/watch?v=DhG94y2oecE│
│Anatomy of a Fall                     │0              │97            │✓Good        │https://www.youtube.com/watch?v=fTrsp5BMloA│
│EO                                    │67             │97            │✓Good ✓Bad   │https://www.youtube.com/watch?v=yBNrdy_1MPc│
│Fremont                               │0              │96            │✓Good        │                                           │
│Shin Ultraman                         │87             │96            │✓Good        │https://www.youtube.com/watch?v=zQkjQcj2A6Y│
│Monster                               │0              │95            │✓Good        │https://www.youtube.com/watch?v=lA9ADgHQ3yk│
│Blue Jean                             │86             │95            │✓Good ✓Bad   │https://www.youtube.com/watch?v=bicfol3o2TU│
│Little Richard: I Am Everything       │97             │95            │✓Good ✓Bad   │https://www.youtube.com/watch?v=_su6zFtQC6A│
│The Innocents                         │86             │95            │✓Good ✓Bad   │                                           │
│De Humani Corporis Fabrica            │0              │95            │✓Good        │https://www.youtube.com/watch?v=zIogZtnJ_BQ│
│Riceboy Sleeps                        │50             │95            │✓Good        │https://www.youtube.com/watch?v=7c2HIHaOODE│
│The Delinquents                       │0              │95            │✓Good        │https://www.youtube.com/watch?v=MAJgRMcotNY│
│Sisu                                  │88             │94            │✓Good ✓Bad   │https://www.youtube.com/watch?v=d2k4QAItiSA│
│Saint Omer                            │51             │94            │✓Good ✓Bad   │https://www.youtube.com/watch?v=9U2qIKH3cYA│
│How to Blow Up a Pipeline             │63             │94            │✓Good ✓Bad   │https://www.youtube.com/watch?v=zaffiCfjD9U│
│Tótem                                 │0              │94            │✓Good        │https://www.youtube.com/watch?v=muox5gk34-0│
└──────────────────────────────────────┴───────────────┴──────────────┴─────────────┴───────────────────────────────────────────┘
Showing 20/142 films
What next? (Press ↑/↓ arrow to move and Enter to select)
‣ Next page
  Previous page
  Inspect a film
  Search by title
  ✗ Not showing only highlights
  Add/remove highlight on film
  Change table sort/rows
  Quit
```

Inspecting a film:

```
┌────────────────────┬───────────────────────────────────────────────────────────────────────────────────────┐
│Title               │Are You There God? It's Me, Margaret.                                                  │
│Director            │Kelly Fremon Craig                                                                     │
│Year                │2023                                                                                   │
│Tag                 │Square Eyes                                                                            │
│Critic Score        │99                                                                                     │
│Audience Score      │95                                                                                     │
│Good review         │It's so innocent. It's really sweet.                                                   │
│Bad review          │This adaptation seems uneasy putting funny, flawed and all-too-realistic               │
│                    │Margaret on screen exactly as she is. Today, it’s not enough to be                     │
│                    │representative: Margaret must be a role model, too.                                    │
│Trailer             │https://www.youtube.com/watch?v=LzRzojHC3iE                                            │
│NZ Film Fest page   │https://www.nziff.co.nz/2023/tamaki-makaurau-auckland/are-you-there-god-its-me-margaret│
│Rotten tomatoes page│https://www.rottentomatoes.com/m/are_you_there_god_its_me_margaret                     │
└────────────────────┴───────────────────────────────────────────────────────────────────────────────────────┘
Press to return
```

Viewing your highlights:

```
┌─────────────────────────────────────┬───────────────┬──────────────┬─────────────┬────────────────────────────────────────────┐
│Title                                │Audience Score │Critics Score │Has Reviews? │Trailer                                     │
├─────────────────────────────────────┼───────────────┼──────────────┼─────────────┼────────────────────────────────────────────┤
│My Name Is Alfred Hitchcock          │0              │100           │✓Good        │https://www.youtube.com/watch?v=OfanYi3LPLQ │
│Nam June Paik: Moon Is the Oldest TV │0              │90            │✓Good ✓Bad   │https://www.youtube.com/watch?v=Kxqxp0R4XRU │
│Loop Track                           │               │              │             │                                            │
└─────────────────────────────────────┴───────────────┴──────────────┴─────────────┴────────────────────────────────────────────┘
Showing 3/142 films
What next? (Press ↑/↓ arrow to move and Enter to select)
‣ Inspect a film
  Search by title
  ✓ Showing only highlights
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

Import film data from the NZ Film Festival website:

```bash
bundle exec ruby scripts/import_nziff_films.rb
```

And then import the Rotten Tomatoes review scores for those films:

```bash
bundle exec ruby scripts/import_rt_reviews.rb
```

Both scripts can be passed `--help` to see some options.

Finally, run the app:

```bash
bundle exec ruby scripts/run.rb
```

### Features:

- See films correlated with reviews and ratings
- Watch trailers
- Mark a film as a highlight to go back to it easily
- Search by title
- Sort by ratings or title
