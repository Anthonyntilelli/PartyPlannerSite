# frozen_string_literal: true

User.destroy_all
Venue.destroy_all
Theme.destroy_all
Party.destroy_all
Invite.destroy_all
Gift.destroy_all

puts 'Active Venue'
fl_venue = Venue.create!(
  name: 'Fun Land',
  zipcode: 12_345,
  state: 'NY',
  city: 'New York',
  street_addr: '1234 My Street',
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
puts 'Active Theme'
sp_theme = Theme.create!(name: 'Space', active: true)
puts 'Inactive Theme'
Theme.create!(name: 'Nature', active: false)
puts 'Tom User'
tom_user = User.create!(
  name: 'Tom Smith',
  email: 'tom@example.com',
  email_confirmation: 'tom@example.com',
  password: 'pw123456',
  password_confirmation: 'pw123456',
  allow_passwordless: false,
  locked: false,
  admin: true
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
puts 'Tom Party'
tm_party = Party.create!(
  name: 'Super Party',
  user: tom_user,
  venue: fl_venue,
  theme: sp_theme,
  event_date: '2020-05-02', # yyyy-mm-dd
  time_slot: 4
)
puts 'Amy Party (same name)'
Party.create!(
  name: 'Super party',
  user: amy_user,
  venue: fl_venue,
  theme: sp_theme,
  event_date: '2020-05-02', # yyyy-mm-dd
  time_slot: 3
)
puts 'Tom invites Amy'
Invite.create!(user: amy_user, party: tm_party, accepted: true)
puts 'Amy\'s gift'
Gift.create!(user: amy_user, party: tm_party, name: 'Toy Plane')
puts 'Unassigned Gift'
Gift.create!(party: tm_party, name: 'Toy Plane')
