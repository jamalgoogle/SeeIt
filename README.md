# SeeIt: Express + PostgreSQL backend

The page (`public/index.html`) is your SeeIt design with every piece of hard-coded data removed. It loads everything from `/api/...`.

## Run it

```bash
npm install
# create the database once (psql, pgAdmin, or:)
psql -U postgres -c "CREATE DATABASE seeit;"

copy .env.example .env        # macOS/Linux: cp .env.example .env
# edit .env: set DATABASE_URL and a long random JWT_SECRET

npm run db:setup              # creates tables + loads the catalog
npm run dev                   # http://localhost:3000
```

`npm run db:reset` drops everything and reseeds. Re-running `npm run db:seed` replaces the catalog and keeps users.

## What needs a login

Browsing the home screen is public. Every action needs a token (`Authorization: Bearer <token>`).
Trailer and stream URLs are never included in public responses, so they cannot be read without an account.

| Section on the page | Public (home screen) | Needs login |
|---|---|---|
| Auth | | `POST /api/auth/signup`, `POST /api/auth/login`, `GET /api/auth/me` (signup/login are open by nature) |
| Hero slider | `GET /api/hero-slides` | `GET /api/hero-slides/:id/trailer` |
| Genres | `GET /api/genres` | `GET /api/genres/:slug/titles` |
| Feature Movies | `GET /api/movies` | `GET /api/titles/:id`, `GET /api/titles/:id/trailer` |
| TV Series | `GET /api/series` | same two endpoints |
| Watchlist "+" button | | `GET /api/watchlist`, `POST /api/watchlist/:titleId`, `DELETE /api/watchlist/:titleId` |
| Live channels | `GET /api/channels` | `GET /api/channels/:id/stream` |
| Coming soon | `GET /api/coming-soon` | `POST /api/coming-soon/:id/remind`, `DELETE /api/coming-soon/:id/remind` |
| Search box | | `GET /api/search?q=` |
| | `GET /api/health` | |

`GET /api/movies`, `/api/series` and `/api/coming-soon` also return `inWatchlist` / `reminded` for the logged-in user when a token is sent.

## Notes

- Passwords are hashed with bcrypt (cost 12). Login errors are identical for "wrong password" and "unknown email". Signup/login are rate-limited (20 per 15 minutes per IP).
- The token is a 7-day JWT kept in `localStorage`. That is simple, but any XSS bug could read it. The page escapes all API data before rendering.
- Helmet's CSP is off because the page uses the Tailwind Play CDN and an inline script. Turn it on after compiling Tailwind.
- The original page had no genre tags per title, so `db/seed.js` assigns some (edit the `titleGenres` map). Only the first live channel had real "now airing" details; the others use placeholders.
