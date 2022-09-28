# FastSyndication

Minimal wrapper around Rust NIFs for fast RSS and Atom feed parsing
- [rss](https://github.com/rust-syndication/rss) for parsing RSS feeds
- [atom](https://github.com/rust-syndication/atom) for parsing Atom feeds

Heavily based on the existing [FastRSS](https://github.com/avencera/fast_rss) wrapper.

## Usage

```elixir
iex(1)>  {:ok, map_of_atom} = FastSyndication.parse_atom("...atom_feed_string...")
iex(2)>  {:ok, map_of_rss} = FastSyndication.parse_rss("...rss_feed_string...")
iex(2)>  {:ok, %Feed{...}} = FastSyndication.parse("...rss_feed_string...")
```
