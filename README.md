# Vibes

An ambient video cafe built with Phoenix LiveView.

The Elixir app and release are `vibes`, with `Vibes` and `VibesWeb` modules. Local development and tests keep the existing `cafe_dev` and `cafe_test` database names so the rename does not replace local data. The session cookie keeps its `_cafe_key` name and signing settings so existing sessions remain valid.

## Requirements

- Erlang/OTP 29.1.2
- Elixir 1.20.4
- PostgreSQL 18.6

The exact local versions are recorded in `.tool-versions`. If PostgreSQL is not installed locally, start it with `docker compose up -d postgres`.

## Setup

1. Run `mix setup`.
2. Start the endpoint with `mix phx.server` or `iex -S mix phx.server`.
3. Visit [localhost:4000](http://localhost:4000).

## Checks

Run `mix precommit`, the JavaScript tests with `node --test test/js/*.test.mjs`, and the migration preservation check with `MIX_ENV=test mix run --no-start scripts/verify-station-migration.exs`. The migration check creates and removes its own temporary database. Build production assets with `MIX_ENV=prod mix assets.deploy`.

Pushes to `main` deploy to Hetzner through Kamal after formatting, compilation, tests, and the production asset build pass. PostgreSQL runs on PlanetScale; application connections use PgBouncer.

See [hosting and operations](docs/hosting.md) and the [guide for deploying another app](docs/deploy-another-app.md).

Station creation, editable settings, playback refresh, and safe seed reruns are described in the [curation guide](docs/curation.md). See [theme image measurements](docs/theme-images.md) and [memory measurement instructions](docs/memory-measurement.md) for the deployment size and capacity checks.
