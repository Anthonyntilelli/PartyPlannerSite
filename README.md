# PartyPlannerSite

Sinatra powered site for planning events and inviting other users.

## ENV configs

- `NO_DNS` set to  `'true'` to disable DNS checks for user email.
- `SENDGRID_API_KEY` - Send grip api key
- `HMAC_URl_KEY` - used for hmac url key, generate via securerandom, must be 64 bits
- `SESSION_KEY`  - used for session secret, generate via securerandom, must be 64 bits

## Routes

Party planner uses before routes for auth checks

- '/pre_auth/*' - Non-Logged in users only
- '/post_auth/*' - Logged in users only
- '/hmac/*' - Must have valid hmac/non-expired to reach.
- '/admin/*' - Logged in admin users only

## Thanks to

- Sinatra Template provided by https://github.com/thebrianemory/corneal
- Favicon provided by https://www.freefavicon.com
