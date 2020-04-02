# PartyPlannerSite

Sinatra powered site for planning events and inviting other users.

## Routes

Party planner uses before routes for auth checks

- '/pre_auth/*' - Non-Logged in users only
- '/post_auth/*' - Logged in users only
- '/hmac/*' - Must have valid hmac/non-expired to reach.
- '/admin/*' - Logged in admin users only

## Thanks to

- Sinatra Template provided by https://github.com/thebrianemory/corneal
- Favicon provided by https://www.freefavicon.com
