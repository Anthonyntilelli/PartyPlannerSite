# frozen_string_literal: true

User.destroy_all
Venue.destroy_all
Theme.destroy_all
Party.destroy_all
Invite.destroy_all

puts 'Active Venue(1)'
fl_venue = Venue.create!(
  name: 'Fun Land',
  zipcode: 12_345,
  state: 'NY',
  city: 'New York',
  street_addr: '1234 My Street',
  active: true
)
puts 'Active Venue(2)'
Venue.create!(
  name: 'Central Dance Ball',
  zipcode: 12_348,
  state: 'NY',
  city: 'New York',
  street_addr: '1346 Great Street',
  active: true
)
puts 'Active Venue(3)'
Venue.create!(
  name: 'Rocken Rave Central',
  zipcode: 12_850,
  state: 'NY',
  city: 'New York',
  street_addr: '1092 Super Ave',
  active: true
)
puts 'Inactive Venue'
Venue.create!(
  name: 'Sad Land',
  zipcode: 12_346,
  state: 'NY',
  city: 'New York',
  street_addr: '1234 My Other Street',
  active: false
)
puts 'Active Theme(1)'
sp_theme = Theme.create!(name: 'Space', active: true)
puts 'Active Theme(2)'
Theme.create!(name: 'Princess', active: true)
puts 'Active Theme(3)'
Theme.create!(name: 'Wild West', active: true)
puts 'Inactive Theme'
Theme.create!(name: 'Nature', active: false)

if ENV['SINATRA_ENV'] == 'development'
  puts 'Tom User'
  tom_user = User.create!(
    name: 'Tom Smith',
    email: 'tom@example.com',
    email_confirmation: 'tom@example.com',
    password: 'pw123456',
    password_confirmation: 'pw123456',
    allow_passwordless: false,
    locked: false,
    admin: false
  )
  puts 'Amy User'
  amy_user = User.create!(
    name: 'Amy Smith',
    email: 'amy@example.com',
    email_confirmation: 'amy@example.com',
    password: 'pw123456',
    password_confirmation: 'pw123456',
    locked: false,
    allow_passwordless: true,
    admin: false
  )
  puts 'Donna User'
  donna_user = User.create!(
    name: 'Donna Smith',
    email: 'donna@example.com',
    email_confirmation: 'donna@example.com',
    password: 'pw123456',
    password_confirmation: 'pw123456',
    allow_passwordless: false,
    locked: false,
    admin: false
  )
  puts 'David User'
  david_user = User.create!(
    name: 'david Smith',
    email: 'david@example.com',
    email_confirmation: 'david@example.com',
    password: 'pw123456',
    password_confirmation: 'pw123456',
    allow_passwordless: false,
    locked: false,
    admin: false
  )
  puts 'Steve User'
  steve_user = User.create!(
    name: 'Steve Smith',
    email: 'steve@example.com',
    email_confirmation: 'steve@example.com',
    password: 'pw123456',
    password_confirmation: 'pw123456',
    allow_passwordless: false,
    locked: false,
    admin: false
  )
  puts 'Admin User'
  admin_user = User.create!(
    name: 'Party Admin',
    email: 'admin@example.com',
    email_confirmation: 'admin@example.com',
    password: 'pw123456',
    password_confirmation: 'pw123456',
    allow_passwordless: false,
    locked: false,
    admin: true
  )
  puts 'Tom Party'
  tm_party = Party.create!(
    name: 'Super Party',
    user: tom_user,
    venue: fl_venue,
    theme: sp_theme,
    event_date: '2020-05-02', # yyyy-mm-dd
    time_slot: 4
  )
  puts 'Amy Party (same name, no invites)'
  Party.create!(
    name: 'Super party',
    user: amy_user,
    venue: fl_venue,
    theme: sp_theme,
    event_date: '2020-05-02', # yyyy-mm-dd
    time_slot: 3
  )
  puts 'Tom invites Amy'
  Invite.create!(user: amy_user, party: tm_party, status: 'pending')
  puts 'Tom invites Donna'
  Invite.create!(user: donna_user, party: tm_party, status: 'accepted')
  puts 'Tom invites David'
  Invite.create!(user: david_user, party: tm_party, status: 'pending')
  puts 'Tom invites Steve'
  Invite.create!(user: steve_user, party: tm_party, status: 'pending')
  puts 'Tom invites admin'
  Invite.create!(user: admin_user, party: tm_party, status: 'declined')
end
