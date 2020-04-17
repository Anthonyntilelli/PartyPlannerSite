# PartyPlannerSite

Sinatra powered site for planning events and inviting other users.
This is the second Learn.co project for flatiron bootcamp.

## ENV configs

- Required:
  - `PARTY_SENDGRID_API_KEY` - Send grid api key
  - `PARTY_SENDGRID_EMAIL` - Send grid TO email address
  - `PARTY_HMAC_URl_KEY` - used for hmac url key, generate via securerandom, must be 64 bits
  - `PARTY_SESSION_KEY`  - used for session secret, generate via securerandom, must be 64 bits
- Debug:
  - `PARTY_DISABLE_DNS` - set to  `'YES'` to disable DNS checks for user email.
  - `PARTY_DISABLE_EMAIL` - set to `'YES'` for email request to silently be ignored.

## Routes

Party planner uses before routes for auth checks

- '/pre_auth/*' - Non-Logged in users only
- '/post_auth/*' - Logged in users only
- '/hmac/*' - Must have valid hmac/non-expired to reach.
- '/admin/*' - Logged in admin users only

## Thanks to

- Sinatra Template provided by https://github.com/thebrianemory/corneal
- Favicon provided by https://www.freefavicon.com
