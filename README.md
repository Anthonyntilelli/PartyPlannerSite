# PartyPlannerSite

Sinatra powered site for planning events and inviting other users.

## Routes

Party planner uses before routes for auth checks

- '/pre_auth/*' - Cannot be reached by those logged in
- '/post_auth/*' - Must be logged in to reach
- '/hmac/*' - Must have valid hmac/non-expired to reach.

## Thanks to

- Sinatra Template provided by https://github.com/thebrianemory/corneal
- Favicon provided by https://www.freefavicon.com
