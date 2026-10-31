# LiveTable demo

The demo site for [LiveTable](https://hex.pm/packages/live_table), real-time data tables for
Phoenix LiveView. It runs at [livetable.gurujada.com](https://livetable.gurujada.com).

Each demo is one LiveView, and every page has a Code tab showing its full source.

| Demo | Shows |
|---|---|
| Contacts | A table straight from an Ecto schema: sorting, multi-column sort, search, pagination, row actions |
| Orders | Every filter type: select, search-as-you-type select, range, toggles; filters in the URL |
| Inventory | Joined tables and computed columns, sorted and searched like any other |
| Leads | Transformers: filters that are functions rewriting the query |
| Projects | Card mode, infinite scroll, bulk actions with the card's own checkbox |
| Storefront | A shop page built on a table: custom controls, cards and empty state |
| Live orders | Live rows and bulk actions, beside a small dashboard |
| 1M products | A million rows with joins, filters, a fixed header and CSV/PDF export |

The home page's table is the live order feed too.

## Running it

```bash
git clone https://github.com/gurujada/livetable_demo
cd livetable_demo
mix setup        # deps, database and seed data (100,000 flagship products)
mix phx.server
```

Then open [localhost:4000](http://localhost:4000). The live site has a million flagship products;
to match it, run `FLAGSHIP_ROWS=1000000 mix run priv/repo/flagship_seeds.exs`.

## The live feed

`Demo.Live.Feed` invents orders and moves them along while someone is watching the Live orders
page or the home page. The first viewer starts it, and it stops 30 seconds after the last one
leaves. It keeps the newest 120 orders. Every change goes out with `LiveTable.broadcast/3`, so
each open table updates, sending only the rows that changed.

## Development

Tidewave is included in development (`plug Tidewave` in the endpoint), at
`http://localhost:4000/tidewave/mcp`.
