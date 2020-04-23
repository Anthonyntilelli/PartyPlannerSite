# PartyPlannerSite

Sinatra powered site for planning events and inviting other users.
This is the second Learn.co project for flatiron bootcamp.

## Install from Source

Project is installed via [Bundler](https://bundler.io/)
Project is coded for development mode

1. clone project
2. run `bundle install`
3. create `party.env` from `party.env.example`
    - see `ENV config` section for more info
4. source `party.env`
5. Create database with `rake db:create:all`
6. Set up with `rake db:migrate` and `rake db:seed`
7. Run `shotgun` to start webserver.

## ENV configs

- Required:
  - `PARTY_SENDGRID_API_KEY` - Send grid api key
  - `PARTY_SENDGRID_EMAIL` - Send grid TO email address
  - `PARTY_HMAC_URl_KEY` - used for hmac url key, generate via securerandom, must be 64 bits
  - `PARTY_SESSION_KEY`  - used for session secret, generate via securerandom, must be 64 bits
- Debug (OPTIONAL):
  - `PARTY_DISABLE_DNS` - set to  `'YES'` to disable DNS checks for user email.
  - `PARTY_DISABLE_EMAIL` - set to `'YES'` for email request to silently be ignored.

## Send Grid

Project uses Send Grid to manage emails for user account creation and passwordless logins.
The api only need enough access to send email. Full access is not needed or recommended.

## Admin User

For security reasons, it is not possible to create an admin user via the website.
Users must be elevated to someone with DB access.  Admin have ability to add/modify/delete
Venues and Themes.

## Routes

Party planner uses before routes for authorization checks.
Finer grain control permission are handles in controllers.

- '/pre_auth/*' - Non-Logged in users only
- '/post_auth/*' - Logged in users only
- '/hmac/*' - Must have valid hmac/non-expired to reach.
- '/admin/*' - Logged in admin users only

## Thanks to

- Sinatra Template provided by https://github.com/thebrianemory/corneal
- Favicon provided by https://www.freefavicon.com
- Frontend Powered by https://getbootstrap.com
